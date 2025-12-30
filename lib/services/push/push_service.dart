/// Push notifications service for WorkOn.
///
/// **PR-F20:** Initial implementation.
///
/// This service manages:
/// - FCM token retrieval and registration
/// - Foreground/background notification handling
/// - Navigation on notification tap
///
/// ## Usage
///
/// ```dart
/// // Initialize at app startup (after auth)
/// await PushService.initialize();
///
/// // Register after login
/// await PushService.registerDeviceIfNeeded();
///
/// // Unregister on logout
/// await PushService.unregisterDevice();
/// ```
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../flutter_flow/flutter_flow_util.dart';
import '../../index.dart';
import '../auth/auth_service.dart';
import 'push_api.dart';
import 'push_config.dart';

/// Callback type for handling notification taps.
typedef NotificationTapCallback = void Function(Map<String, dynamic> data);

/// Service that manages push notifications.
///
/// All operations are NO-OP when [PushConfig.enabled] is `false`.
abstract final class PushService {
  static const PushApi _api = PushApi();

  /// Current FCM token (null if not retrieved or disabled).
  static String? _fcmToken;

  /// Whether the service has been initialized.
  static bool _initialized = false;

  /// Navigator key for navigation from notifications.
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Scaffold messenger key for showing snackbars.
  static GlobalKey<ScaffoldMessengerState>? _scaffoldKey;

  /// Sets the navigator key for notification-triggered navigation.
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// Sets the scaffold messenger key for foreground snackbars.
  static void setScaffoldKey(GlobalKey<ScaffoldMessengerState> key) {
    _scaffoldKey = key;
  }

  /// Initializes the push service.
  ///
  /// Call this at app startup, after auth is set up.
  ///
  /// Returns `true` if initialized successfully.
  static Future<bool> initialize() async {
    if (_initialized) {
      debugPrint('[PushService] Already initialized');
      return true;
    }

    if (!PushConfig.enabled) {
      debugPrint('[PushService] Push disabled by config');
      _initialized = true;
      return true;
    }

    try {
      debugPrint('[PushService] Initializing...');

      // TODO(PR-F20): When Firebase is configured, uncomment:
      // await Firebase.initializeApp();
      // await _setupFCM();

      _initialized = true;
      debugPrint('[PushService] Initialized (Firebase not configured yet)');
      return true;
    } catch (e) {
      debugPrint('[PushService] Initialization failed: $e');
      return false;
    }
  }

  /// Registers the device for push notifications.
  ///
  /// Call this after successful login.
  ///
  /// Returns `true` if registered successfully.
  static Future<bool> registerDeviceIfNeeded() async {
    if (!PushConfig.enabled) {
      debugPrint('[PushService] registerDevice: push disabled');
      return true;
    }

    if (!AuthService.hasSession) {
      debugPrint('[PushService] registerDevice: no session');
      return false;
    }

    // TODO(PR-F20): When Firebase is configured, get real token:
    // final token = await FirebaseMessaging.instance.getToken();
    final token = _fcmToken;

    if (token == null || token.isEmpty) {
      debugPrint('[PushService] registerDevice: no FCM token');
      return false;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';
    final success = await _api.registerDevice(token: token, platform: platform);

    if (success) {
      debugPrint('[PushService] Device registered successfully');
    } else {
      debugPrint('[PushService] Device registration failed');
    }

    return success;
  }

  /// Unregisters the device from push notifications.
  ///
  /// Call this on logout.
  static Future<void> unregisterDevice() async {
    if (!PushConfig.enabled) {
      debugPrint('[PushService] unregisterDevice: push disabled');
      return;
    }

    final token = _fcmToken;
    if (token == null || token.isEmpty) {
      debugPrint('[PushService] unregisterDevice: no token to unregister');
      return;
    }

    await _api.unregisterDevice(token: token);
    _fcmToken = null;
    debugPrint('[PushService] Device unregistered');
  }

  /// Handles a notification tap.
  ///
  /// Called when user taps a notification (foreground or background).
  static void handleNotificationTap(Map<String, dynamic> data) {
    debugPrint('[PushService] Notification tapped: ${data.keys}');

    final type = data['type']?.toString();
    final conversationId = data['conversationId']?.toString();

    if (type == 'message' && conversationId != null) {
      _navigateToChat(conversationId, data);
    } else {
      _navigateToMessages();
    }
  }

  /// Handles a foreground notification.
  ///
  /// Shows a snackbar if configured.
  static void handleForegroundNotification(Map<String, dynamic> data) {
    debugPrint('[PushService] Foreground notification: ${data.keys}');

    if (!PushConfig.showForegroundSnackbar) return;

    final title = data['title']?.toString() ?? 'Nouveau message';
    final body = data['body']?.toString() ?? '';
    final conversationId = data['conversationId']?.toString();

    _showNotificationSnackbar(
      title: title,
      body: body,
      onTap: () {
        if (conversationId != null) {
          _navigateToChat(conversationId, data);
        } else {
          _navigateToMessages();
        }
      },
    );
  }

  /// Shows a snackbar for foreground notifications.
  static void _showNotificationSnackbar({
    required String title,
    required String body,
    VoidCallback? onTap,
  }) {
    final context = _navigatorKey?.currentContext;
    if (context == null) {
      debugPrint('[PushService] Cannot show snackbar: no context');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            onTap?.call();
          },
          child: Row(
            children: [
              const Icon(Icons.message, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (body.isNotEmpty)
                      Text(
                        body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Voir',
          textColor: Colors.white,
          onPressed: () {
            onTap?.call();
          },
        ),
      ),
    );
  }

  /// Navigates to the chat screen.
  static void _navigateToChat(String conversationId, Map<String, dynamic> data) {
    final context = _navigatorKey?.currentContext;
    if (context == null) {
      debugPrint('[PushService] Cannot navigate: no context');
      return;
    }

    final senderName = data['senderName']?.toString() ?? 'Conversation';

    context.pushNamed(
      ChatWidget.routeName,
      queryParameters: {
        'conversationId': conversationId,
        'participantName': senderName,
      },
    );
  }

  /// Navigates to the messages list.
  static void _navigateToMessages() {
    final context = _navigatorKey?.currentContext;
    if (context == null) {
      debugPrint('[PushService] Cannot navigate: no context');
      return;
    }

    context.pushNamed(MessagesWidget.routeName);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Firebase Setup (uncomment when Firebase is configured)
  // ─────────────────────────────────────────────────────────────────────────

  /*
  /// Sets up Firebase Cloud Messaging.
  static Future<void> _setupFCM() async {
    final messaging = FirebaseMessaging.instance;

    // Request permissions (iOS)
    if (Platform.isIOS) {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[PushService] iOS permission: ${settings.authorizationStatus}');
    }

    // Get FCM token
    _fcmToken = await messaging.getToken();
    debugPrint('[PushService] FCM token retrieved');

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('[PushService] FCM token refreshed');
      registerDeviceIfNeeded();
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = {
        ...message.data,
        'title': message.notification?.title,
        'body': message.notification?.body,
      };
      handleForegroundNotification(data);
    });

    // Handle background/terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationTap(message.data);
    });

    // Check if app was opened from notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      // Delay to ensure navigation is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        handleNotificationTap(initialMessage.data);
      });
    }
  }
  */

  /// Resets the service state (for testing).
  @visibleForTesting
  static void reset() {
    _initialized = false;
    _fcmToken = null;
  }
}

