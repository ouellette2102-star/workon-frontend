/// Notification preferences persistence for WorkOn.
///
/// **PR-08:** Stores user notification preferences locally.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores notification preferences locally using SharedPreferences.
///
/// Since no backend endpoint exists for notification preferences,
/// we persist them locally and sync device registration accordingly.
class NotificationPrefs {
  NotificationPrefs._();

  static const String _keyPrefix = 'notification_pref_';

  // Preference keys
  static const String keyGeneralEnabled = '${_keyPrefix}general_enabled';
  static const String keySecurityAlerts = '${_keyPrefix}security_alerts';
  static const String keyAppUpdates = '${_keyPrefix}app_updates';
  static const String keyBillReminder = '${_keyPrefix}bill_reminder';
  static const String keyPromotions = '${_keyPrefix}promotions';
  static const String keyDiscounts = '${_keyPrefix}discounts';
  static const String keyNewServices = '${_keyPrefix}new_services';
  static const String keyAppNews = '${_keyPrefix}app_news';
  static const String keyEventInvitations = '${_keyPrefix}event_invitations';
  static const String keyRewardUpdates = '${_keyPrefix}reward_updates';
  static const String keyAnnouncements = '${_keyPrefix}announcements';
  static const String keyTipsTutorials = '${_keyPrefix}tips_tutorials';
  static const String keyMessages = '${_keyPrefix}messages';
  static const String keyMissionUpdates = '${_keyPrefix}mission_updates';

  /// Device token stored after registration.
  static const String keyDeviceToken = '${_keyPrefix}device_token';

  /// Whether device is currently registered.
  static const String keyDeviceRegistered = '${_keyPrefix}device_registered';

  static SharedPreferences? _prefs;

  /// Initializes the preferences store.
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    debugPrint('[NotificationPrefs] Initialized');
  }

  /// Ensures prefs is initialized before use.
  static Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // General notification (master toggle)
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether push notifications are enabled globally.
  ///
  /// This is the master toggle that controls device registration.
  static Future<bool> isGeneralEnabled() async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(keyGeneralEnabled) ?? true; // Default: enabled
  }

  /// Sets the general notification preference and triggers device
  /// registration/unregistration.
  static Future<void> setGeneralEnabled(bool enabled) async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(keyGeneralEnabled, enabled);
    debugPrint('[NotificationPrefs] General enabled: $enabled');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Individual preferences
  // ─────────────────────────────────────────────────────────────────────────

  static Future<bool> getBool(String key, {bool defaultValue = true}) async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(key, value);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Device registration state
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether the device is currently registered for push.
  static Future<bool> isDeviceRegistered() async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(keyDeviceRegistered) ?? false;
  }

  /// Marks the device as registered.
  static Future<void> setDeviceRegistered(bool registered) async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(keyDeviceRegistered, registered);
  }

  /// Gets the stored device token.
  static Future<String?> getDeviceToken() async {
    final prefs = await _ensurePrefs();
    return prefs.getString(keyDeviceToken);
  }

  /// Stores the device token after retrieval.
  static Future<void> setDeviceToken(String? token) async {
    final prefs = await _ensurePrefs();
    if (token == null) {
      await prefs.remove(keyDeviceToken);
    } else {
      await prefs.setString(keyDeviceToken, token);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Load all preferences at once
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads all notification preferences.
  static Future<NotificationPrefsSnapshot> loadAll() async {
    final prefs = await _ensurePrefs();

    return NotificationPrefsSnapshot(
      generalEnabled: prefs.getBool(keyGeneralEnabled) ?? true,
      securityAlerts: prefs.getBool(keySecurityAlerts) ?? true,
      appUpdates: prefs.getBool(keyAppUpdates) ?? true,
      billReminder: prefs.getBool(keyBillReminder) ?? true,
      promotions: prefs.getBool(keyPromotions) ?? false,
      discounts: prefs.getBool(keyDiscounts) ?? true,
      newServices: prefs.getBool(keyNewServices) ?? true,
      appNews: prefs.getBool(keyAppNews) ?? true,
      eventInvitations: prefs.getBool(keyEventInvitations) ?? false,
      rewardUpdates: prefs.getBool(keyRewardUpdates) ?? true,
      announcements: prefs.getBool(keyAnnouncements) ?? true,
      tipsTutorials: prefs.getBool(keyTipsTutorials) ?? false,
      messages: prefs.getBool(keyMessages) ?? true,
      missionUpdates: prefs.getBool(keyMissionUpdates) ?? true,
    );
  }

  /// Clears all notification preferences (on logout).
  static Future<void> clear() async {
    final prefs = await _ensurePrefs();
    final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
    debugPrint('[NotificationPrefs] Cleared all preferences');
  }
}

/// Snapshot of all notification preferences.
class NotificationPrefsSnapshot {
  const NotificationPrefsSnapshot({
    required this.generalEnabled,
    required this.securityAlerts,
    required this.appUpdates,
    required this.billReminder,
    required this.promotions,
    required this.discounts,
    required this.newServices,
    required this.appNews,
    required this.eventInvitations,
    required this.rewardUpdates,
    required this.announcements,
    required this.tipsTutorials,
    required this.messages,
    required this.missionUpdates,
  });

  final bool generalEnabled;
  final bool securityAlerts;
  final bool appUpdates;
  final bool billReminder;
  final bool promotions;
  final bool discounts;
  final bool newServices;
  final bool appNews;
  final bool eventInvitations;
  final bool rewardUpdates;
  final bool announcements;
  final bool tipsTutorials;
  final bool messages;
  final bool missionUpdates;
}

