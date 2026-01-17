/// Legal consent persistence for WorkOn.
///
/// **PR-13:** Stores user consent for Terms of Service and Privacy Policy.
/// Includes timestamp for auditability.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores legal consent data locally using SharedPreferences.
///
/// No backend endpoint exists for consent, so we persist locally.
/// The timestamp is stored for auditability purposes.
class ConsentStore {
  ConsentStore._();

  static const String _keyPrefix = 'legal_consent_';

  // Storage keys
  static const String keyTosAccepted = '${_keyPrefix}tos_accepted';
  static const String keyPrivacyAccepted = '${_keyPrefix}privacy_accepted';
  static const String keyConsentTimestamp = '${_keyPrefix}timestamp';
  static const String keyConsentVersion = '${_keyPrefix}version';

  /// Current version of the legal documents.
  /// Increment this when TOS/Privacy are updated to require re-consent.
  static const String currentVersion = '1.0.0';

  static SharedPreferences? _prefs;

  /// Initializes the consent store.
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    debugPrint('[ConsentStore] Initialized');
  }

  /// Ensures prefs is initialized before use.
  static Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Consent Status
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns true if the user has accepted both TOS and Privacy Policy.
  static Future<bool> hasConsented() async {
    final prefs = await _ensurePrefs();
    final tosAccepted = prefs.getBool(keyTosAccepted) ?? false;
    final privacyAccepted = prefs.getBool(keyPrivacyAccepted) ?? false;
    final version = prefs.getString(keyConsentVersion);

    // Require re-consent if version has changed
    if (version != currentVersion) {
      return false;
    }

    return tosAccepted && privacyAccepted;
  }

  /// Records user consent with timestamp.
  ///
  /// Call this when user checks the consent checkbox and signs up.
  static Future<void> recordConsent() async {
    final prefs = await _ensurePrefs();
    final timestamp = DateTime.now().toIso8601String();

    await prefs.setBool(keyTosAccepted, true);
    await prefs.setBool(keyPrivacyAccepted, true);
    await prefs.setString(keyConsentTimestamp, timestamp);
    await prefs.setString(keyConsentVersion, currentVersion);

    debugPrint('[ConsentStore] Consent recorded at $timestamp (v$currentVersion)');
  }

  /// Gets the timestamp when consent was given.
  /// Returns null if no consent recorded.
  static Future<DateTime?> getConsentTimestamp() async {
    final prefs = await _ensurePrefs();
    final timestamp = prefs.getString(keyConsentTimestamp);
    if (timestamp == null) return null;

    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('[ConsentStore] Invalid timestamp: $timestamp');
      return null;
    }
  }

  /// Gets the version of legal documents that were consented to.
  static Future<String?> getConsentVersion() async {
    final prefs = await _ensurePrefs();
    return prefs.getString(keyConsentVersion);
  }

  /// Clears consent data (e.g., on logout or for re-consent).
  static Future<void> clearConsent() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(keyTosAccepted);
    await prefs.remove(keyPrivacyAccepted);
    await prefs.remove(keyConsentTimestamp);
    await prefs.remove(keyConsentVersion);

    debugPrint('[ConsentStore] Consent cleared');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Audit Data
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a map of consent data for audit purposes.
  static Future<Map<String, dynamic>> getAuditData() async {
    final prefs = await _ensurePrefs();
    return {
      'tosAccepted': prefs.getBool(keyTosAccepted) ?? false,
      'privacyAccepted': prefs.getBool(keyPrivacyAccepted) ?? false,
      'timestamp': prefs.getString(keyConsentTimestamp),
      'version': prefs.getString(keyConsentVersion),
      'currentVersion': currentVersion,
    };
  }
}

