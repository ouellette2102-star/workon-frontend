/// Remote configuration loader with TTL cache.
///
/// Fetches configuration from a remote JSON endpoint and caches the result.
/// Fail-open design: if fetch/parse fails, app continues with local defaults.
///
/// **PR-H3:** Remote config with TTL cache.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Remote Config Snapshot
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable snapshot of remote configuration values.
///
/// All fields are nullable; null means "use local default".
class RemoteConfigSnapshot {
  const RemoteConfigSnapshot({
    this.maintenanceMode,
    this.disableAuth,
    this.disablePayments,
    this.minAppVersion,
    this.storeUrlIos,
    this.storeUrlAndroid,
    this.discoverySwipe,
    this.discoveryMap,
  });

  final bool? maintenanceMode;
  final bool? disableAuth;
  final bool? disablePayments;
  final String? minAppVersion;
  final String? storeUrlIos;
  final String? storeUrlAndroid;
  final bool? discoverySwipe;
  final bool? discoveryMap;

  /// Parses JSON map into a snapshot.
  /// Unknown/invalid fields are ignored (fail-open).
  factory RemoteConfigSnapshot.fromJson(Map<String, dynamic> json) {
    return RemoteConfigSnapshot(
      maintenanceMode: _parseBool(json['maintenanceMode']),
      disableAuth: _parseBool(json['disableAuth']),
      disablePayments: _parseBool(json['disablePayments']),
      minAppVersion: _parseString(json['minAppVersion']),
      storeUrlIos: _parseString(json['storeUrlIos']),
      storeUrlAndroid: _parseString(json['storeUrlAndroid']),
      discoverySwipe: _parseBool(json['discoverySwipe']),
      discoveryMap: _parseBool(json['discoveryMap']),
    );
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  @override
  String toString() => 'RemoteConfigSnapshot('
      'maintenance=$maintenanceMode, '
      'disableAuth=$disableAuth, '
      'disablePayments=$disablePayments, '
      'minVersion=$minAppVersion)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Remote Config Loader
// ─────────────────────────────────────────────────────────────────────────────

/// Remote configuration loader with TTL caching.
///
/// Usage:
/// ```dart
/// final snapshot = await RemoteConfig.get();
/// if (snapshot?.maintenanceMode == true) { ... }
/// ```
abstract final class RemoteConfig {
  // ─────────────────────────────────────────────────────────────────────────
  // Configuration URLs (dart-define per environment)
  // ─────────────────────────────────────────────────────────────────────────

  static const String _urlDev = String.fromEnvironment(
    'REMOTE_CONFIG_URL_DEV',
    defaultValue: '',
  );

  static const String _urlStaging = String.fromEnvironment(
    'REMOTE_CONFIG_URL_STAGING',
    defaultValue: '',
  );

  static const String _urlProd = String.fromEnvironment(
    'REMOTE_CONFIG_URL_PROD',
    defaultValue: '',
  );

  /// Returns the config URL for current environment, or empty if not set.
  static String get _activeUrl {
    switch (AppConfig.env) {
      case AppEnv.dev:
        return _urlDev;
      case AppEnv.staging:
        return _urlStaging;
      case AppEnv.prod:
        return _urlProd;
    }
  }

  /// Returns true if remote config is enabled (URL is set).
  static bool get isEnabled => _activeUrl.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // TTL Cache
  // ─────────────────────────────────────────────────────────────────────────

  /// Default TTL in seconds (5 minutes).
  static const int _defaultTtlSeconds = 300;

  /// Last successfully fetched snapshot.
  static RemoteConfigSnapshot? _cachedSnapshot;

  /// Timestamp of last successful fetch.
  static DateTime? _lastFetchAt;

  /// In-flight fetch future (for deduplication).
  static Completer<RemoteConfigSnapshot?>? _inFlightFetch;

  /// HTTP client (reuse for efficiency).
  static final http.Client _client = http.Client();

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns the current cached snapshot (may be null if not fetched yet).
  static RemoteConfigSnapshot? get current => _cachedSnapshot;

  /// Fetches remote config with TTL caching.
  ///
  /// - If [force] is true, ignores TTL and fetches fresh data.
  /// - If cache is valid (within TTL), returns cached snapshot.
  /// - Concurrent calls are deduplicated (one fetch at a time).
  /// - On error, returns null (fail-open).
  static Future<RemoteConfigSnapshot?> get({bool force = false}) async {
    // Not enabled? Return null immediately.
    if (!isEnabled) return null;

    // Check TTL (unless forced)
    if (!force && _isCacheValid()) {
      return _cachedSnapshot;
    }

    // Dedupe: if fetch already in progress, wait for it
    if (_inFlightFetch != null) {
      return _inFlightFetch!.future;
    }

    // Start new fetch
    _inFlightFetch = Completer<RemoteConfigSnapshot?>();

    try {
      final snapshot = await _fetchRemote();
      if (snapshot != null) {
        _cachedSnapshot = snapshot;
        _lastFetchAt = DateTime.now();
        _logDebug('Remote config fetched successfully');
      }
      _inFlightFetch!.complete(snapshot);
      return snapshot;
    } catch (e) {
      _logDebug('Remote config fetch failed: ${e.runtimeType}');
      _inFlightFetch!.complete(_cachedSnapshot); // Return stale cache on error
      return _cachedSnapshot;
    } finally {
      _inFlightFetch = null;
    }
  }

  /// Clears the cache (for testing or forced refresh).
  static void clearCache() {
    _cachedSnapshot = null;
    _lastFetchAt = null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Internal
  // ─────────────────────────────────────────────────────────────────────────

  static bool _isCacheValid() {
    if (_cachedSnapshot == null || _lastFetchAt == null) return false;
    final age = DateTime.now().difference(_lastFetchAt!).inSeconds;
    return age < _defaultTtlSeconds;
  }

  static Future<RemoteConfigSnapshot?> _fetchRemote() async {
    final url = _activeUrl;
    if (url.isEmpty) return null;

    try {
      final uri = Uri.parse(url);
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _logDebug('Remote config HTTP ${response.statusCode}');
        return null;
      }

      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic>) {
        _logDebug('Remote config invalid JSON format');
        return null;
      }

      return RemoteConfigSnapshot.fromJson(json);
    } on FormatException catch (_) {
      _logDebug('Remote config JSON parse error');
      return null;
    } on TimeoutException catch (_) {
      _logDebug('Remote config timeout');
      return null;
    } catch (e) {
      // Catch-all for network errors, etc.
      _logDebug('Remote config error: ${e.runtimeType}');
      return null;
    }
  }

  /// Debug-only logging (no PII, no query params).
  static void _logDebug(String message) {
    if (!kDebugMode) return;
    // Log only host (no query params for safety)
    final hostInfo = _activeUrl.isNotEmpty
        ? Uri.tryParse(_activeUrl)?.host ?? 'unknown'
        : 'disabled';
    debugPrint('[RemoteConfig:$hostInfo] $message');
  }
}

