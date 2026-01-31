/// Notification count service for WorkOn.
///
/// **PR-FIX-04:** Provides unread notification count for badge display.
/// Currently returns a placeholder until backend API is available.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Service that manages notification count state.
///
/// ## Usage
///
/// ```dart
/// // Listen to count changes
/// NotificationCountService.stream.listen((count) {
///   setState(() => _unreadCount = count);
/// });
///
/// // Refresh count from backend
/// await NotificationCountService.refresh();
///
/// // Mark all as read
/// await NotificationCountService.markAllRead();
/// ```
abstract final class NotificationCountService {
  static final _controller = StreamController<int>.broadcast();
  static int _count = 0;
  static bool _initialized = false;

  /// Stream of unread notification counts.
  static Stream<int> get stream => _controller.stream;

  /// Current unread count.
  static int get count => _count;

  /// Whether there are unread notifications.
  static bool get hasUnread => _count > 0;

  /// Initializes the service and loads initial count.
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    debugPrint('[NotificationCountService] Initialized');

    // Load initial count
    await refresh();
  }

  /// Refreshes the unread count from backend.
  ///
  /// TODO: Replace with actual API call when backend is ready.
  /// For now, returns 0 (no notifications).
  static Future<void> refresh() async {
    try {
      debugPrint('[NotificationCountService] Refreshing count...');

      // TODO: Call backend API
      // final response = await ApiClient.get('/notifications/unread-count');
      // final newCount = response['count'] as int;

      // For now, always 0 until backend is ready
      const newCount = 0;

      if (newCount != _count) {
        _count = newCount;
        _controller.add(_count);
        debugPrint('[NotificationCountService] Count updated: $_count');
      }
    } catch (e) {
      debugPrint('[NotificationCountService] Error refreshing: $e');
    }
  }

  /// Marks all notifications as read.
  static Future<void> markAllRead() async {
    try {
      debugPrint('[NotificationCountService] Marking all as read...');

      // TODO: Call backend API
      // await ApiClient.post('/notifications/mark-all-read');

      _count = 0;
      _controller.add(_count);
    } catch (e) {
      debugPrint('[NotificationCountService] Error marking read: $e');
    }
  }

  /// Increments count (for local push notification handling).
  static void increment() {
    _count++;
    _controller.add(_count);
    debugPrint('[NotificationCountService] Incremented to: $_count');
  }

  /// Sets count directly (for sync with backend).
  static void setCount(int newCount) {
    if (newCount >= 0 && newCount != _count) {
      _count = newCount;
      _controller.add(_count);
      debugPrint('[NotificationCountService] Set to: $_count');
    }
  }

  /// Resets the service state (on logout).
  static void reset() {
    _count = 0;
    _controller.add(_count);
    _initialized = false;
    debugPrint('[NotificationCountService] Reset');
  }

  /// Disposes the service.
  static void dispose() {
    _controller.close();
  }
}

