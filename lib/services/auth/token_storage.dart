/// Token storage service for WorkOn.
///
/// Provides persistent storage for authentication tokens using SharedPreferences.
/// This ensures tokens survive app restarts.
///
/// **PR-F04:** Token persistence implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting authentication tokens.
///
/// Uses SharedPreferences for storage (secure enough for most mobile apps).
/// For higher security requirements, consider flutter_secure_storage.
///
/// ## Usage
///
/// ```dart
/// // Initialize at app startup
/// await TokenStorage.initialize();
///
/// // Save token after login
/// await TokenStorage.setToken('jwt_token_here');
///
/// // Retrieve token
/// final token = TokenStorage.getToken();
///
/// // Clear on logout
/// await TokenStorage.clearToken();
/// ```
abstract final class TokenStorage {
  // ─────────────────────────────────────────────────────────────────────────
  // Storage Keys
  // ─────────────────────────────────────────────────────────────────────────

  static const String _accessTokenKey = 'workon_access_token';
  static const String _refreshTokenKey = 'workon_refresh_token';
  static const String _tokenExpiryKey = 'workon_token_expiry';

  // ─────────────────────────────────────────────────────────────────────────
  // In-Memory Cache
  // ─────────────────────────────────────────────────────────────────────────

  /// Cached access token for fast access.
  static String? _cachedAccessToken;

  /// Cached refresh token.
  static String? _cachedRefreshToken;

  /// Cached expiry time.
  static DateTime? _cachedExpiry;

  /// SharedPreferences instance.
  static SharedPreferences? _prefs;

  /// Whether storage has been initialized.
  static bool _initialized = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the token storage.
  ///
  /// Must be called once at app startup, typically in main.dart.
  ///
  /// Returns `true` if a valid token was restored.
  static Future<bool> initialize() async {
    if (_initialized) {
      debugPrint('[TokenStorage] Already initialized');
      return _cachedAccessToken != null;
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;

      // Restore cached values
      _cachedAccessToken = _prefs?.getString(_accessTokenKey);
      _cachedRefreshToken = _prefs?.getString(_refreshTokenKey);

      final expiryMs = _prefs?.getInt(_tokenExpiryKey);
      if (expiryMs != null) {
        _cachedExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
      }

      final hasToken = _cachedAccessToken != null && _cachedAccessToken!.isNotEmpty;
      debugPrint('[TokenStorage] Initialized, has token: $hasToken');

      return hasToken;
    } catch (e) {
      debugPrint('[TokenStorage] Init error: $e');
      _initialized = true; // Mark as initialized to prevent retry loop
      return false;
    }
  }

  /// Ensures storage is initialized before use.
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Token Access (Sync - uses cache)
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns the current access token, or null if not set.
  ///
  /// This is a synchronous operation using the in-memory cache.
  /// Call [initialize] first to load from storage.
  static String? getToken() => _cachedAccessToken;

  /// Returns the current refresh token, or null if not set.
  static String? getRefreshToken() => _cachedRefreshToken;

  /// Returns the token expiry time, or null if not set.
  static DateTime? getExpiry() => _cachedExpiry;

  /// Returns `true` if a token exists.
  static bool get hasToken => _cachedAccessToken != null && _cachedAccessToken!.isNotEmpty;

  /// Returns `true` if the token is expired.
  static bool get isExpired {
    if (_cachedExpiry == null) return false; // No expiry = assume valid
    return DateTime.now().isAfter(_cachedExpiry!);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Token Modification (Async - persists to storage)
  // ─────────────────────────────────────────────────────────────────────────

  /// Saves the access token to persistent storage.
  ///
  /// Also updates the in-memory cache for fast access.
  static Future<void> setToken(String token) async {
    await _ensureInitialized();

    _cachedAccessToken = token;
    await _prefs?.setString(_accessTokenKey, token);
    debugPrint('[TokenStorage] Token saved');
  }

  /// Saves the refresh token to persistent storage.
  static Future<void> setRefreshToken(String token) async {
    await _ensureInitialized();

    _cachedRefreshToken = token;
    await _prefs?.setString(_refreshTokenKey, token);
    debugPrint('[TokenStorage] Refresh token saved');
  }

  /// Saves the token expiry time.
  static Future<void> setExpiry(DateTime expiry) async {
    await _ensureInitialized();

    _cachedExpiry = expiry;
    await _prefs?.setInt(_tokenExpiryKey, expiry.millisecondsSinceEpoch);
    debugPrint('[TokenStorage] Expiry saved: $expiry');
  }

  /// Saves all token data at once.
  ///
  /// Convenience method for after login.
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    await _ensureInitialized();

    await setToken(accessToken);
    if (refreshToken != null) {
      await setRefreshToken(refreshToken);
    }
    if (expiresAt != null) {
      await setExpiry(expiresAt);
    }
  }

  /// Clears all stored tokens.
  ///
  /// Call this on logout or when tokens are invalidated.
  static Future<void> clearToken() async {
    await _ensureInitialized();

    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _cachedExpiry = null;

    await _prefs?.remove(_accessTokenKey);
    await _prefs?.remove(_refreshTokenKey);
    await _prefs?.remove(_tokenExpiryKey);

    debugPrint('[TokenStorage] Tokens cleared');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Debug
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns debug info about current token state.
  static Map<String, dynamic> debugInfo() {
    return {
      'initialized': _initialized,
      'hasToken': hasToken,
      'isExpired': isExpired,
      'expiry': _cachedExpiry?.toIso8601String(),
    };
  }
}

