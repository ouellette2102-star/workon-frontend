/// Notification preferences service for WorkOn.
///
/// **FL-NOTIF-PREFS:** Initial implementation.
library;

import 'package:flutter/foundation.dart';

import 'notification_prefs_api.dart';
import 'notification_prefs_models.dart';

/// Service for managing notification preferences.
class NotificationPrefsService {
  NotificationPrefsService._();

  static final _api = const NotificationPrefsApi();

  /// Cached preferences.
  static List<NotificationPreference>? _preferencesCache;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 5);

  /// Clears the cache.
  static void clearCache() {
    _preferencesCache = null;
    _cacheTime = null;
    debugPrint('[NotificationPrefsService] Cache cleared');
  }

  /// Returns true if cache is valid.
  static bool _isCacheValid() {
    if (_preferencesCache == null || _cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < _cacheDuration;
  }

  /// Gets all preferences.
  static Future<List<NotificationPreference>> getPreferences({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isCacheValid() && _preferencesCache != null) {
      debugPrint('[NotificationPrefsService] Returning cached preferences');
      return _preferencesCache!;
    }

    debugPrint('[NotificationPrefsService] Fetching preferences');
    final prefs = await _api.getPreferences();

    _preferencesCache = prefs;
    _cacheTime = DateTime.now();

    return prefs;
  }

  /// Gets preferences grouped by category.
  static Future<Map<String, List<NotificationPreference>>> getGroupedPreferences({
    bool forceRefresh = false,
  }) async {
    final prefs = await getPreferences(forceRefresh: forceRefresh);

    final grouped = <String, List<NotificationPreference>>{};
    for (final pref in prefs) {
      final category = pref.notificationType.category;
      grouped.putIfAbsent(category, () => []).add(pref);
    }

    return grouped;
  }

  /// Gets a specific preference.
  static Future<NotificationPreference> getPreference(NotificationType type) async {
    // Check cache first
    if (_preferencesCache != null) {
      try {
        return _preferencesCache!.firstWhere(
          (p) => p.notificationType == type,
        );
      } catch (_) {
        // Not in cache
      }
    }

    debugPrint('[NotificationPrefsService] Fetching preference: ${type.value}');
    return _api.getPreference(type);
  }

  /// Updates a preference.
  static Future<NotificationPreference> updatePreference(
    NotificationType type, {
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
  }) async {
    debugPrint('[NotificationPrefsService] Updating preference: ${type.value}');

    final dto = UpdatePreferenceDto(
      pushEnabled: pushEnabled,
      emailEnabled: emailEnabled,
      smsEnabled: smsEnabled,
    );

    final updated = await _api.updatePreference(type, dto);

    // Update cache
    if (_preferencesCache != null) {
      final index = _preferencesCache!.indexWhere(
        (p) => p.notificationType == type,
      );
      if (index >= 0) {
        _preferencesCache![index] = updated;
      } else {
        _preferencesCache!.add(updated);
      }
    }

    return updated;
  }

  /// Toggles push notifications for a type.
  static Future<NotificationPreference> togglePush(
    NotificationType type,
    bool enabled,
  ) async {
    return updatePreference(type, pushEnabled: enabled);
  }

  /// Toggles email notifications for a type.
  static Future<NotificationPreference> toggleEmail(
    NotificationType type,
    bool enabled,
  ) async {
    return updatePreference(type, emailEnabled: enabled);
  }

  /// Toggles SMS notifications for a type.
  static Future<NotificationPreference> toggleSms(
    NotificationType type,
    bool enabled,
  ) async {
    return updatePreference(type, smsEnabled: enabled);
  }

  /// Sets quiet hours for all notifications.
  static Future<void> setQuietHours({
    required String? start,
    required String? end,
    String? timezone,
  }) async {
    debugPrint('[NotificationPrefsService] Setting quiet hours: $start - $end');

    final dto = SetQuietHoursDto(
      quietHoursStart: start,
      quietHoursEnd: end,
      timezone: timezone,
    );

    await _api.setQuietHours(dto);

    // Invalidate cache
    clearCache();
  }

  /// Unsubscribes from all marketing notifications.
  static Future<void> unsubscribeFromMarketing() async {
    debugPrint('[NotificationPrefsService] Unsubscribing from marketing');
    await _api.unsubscribeFromMarketing();

    // Invalidate cache
    clearCache();
  }

  /// Initializes default preferences for a new user.
  static Future<void> initializeDefaults() async {
    debugPrint('[NotificationPrefsService] Initializing defaults');
    await _api.initializeDefaults();

    // Invalidate cache
    clearCache();
  }

  /// Returns whether any preference has quiet hours configured.
  static bool get hasQuietHours {
    if (_preferencesCache == null || _preferencesCache!.isEmpty) return false;
    final first = _preferencesCache!.first;
    return first.quietHoursStart != null && first.quietHoursEnd != null;
  }

  /// Returns quiet hours if configured.
  static ({String start, String end, String? timezone})? get quietHours {
    if (_preferencesCache == null || _preferencesCache!.isEmpty) return null;
    final first = _preferencesCache!.first;
    if (first.quietHoursStart == null || first.quietHoursEnd == null) return null;
    return (
      start: first.quietHoursStart!,
      end: first.quietHoursEnd!,
      timezone: first.timezone,
    );
  }
}
