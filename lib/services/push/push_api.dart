/// Push API client for WorkOn.
///
/// **PR-F20:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../auth/auth_service.dart';

/// API client for push notification device registration.
class PushApi {
  const PushApi();

  /// Registers a device token for push notifications.
  ///
  /// Calls `POST /devices/register` with Bearer token.
  ///
  /// [token] is the FCM device token (NEVER logged).
  /// [platform] is 'android' or 'ios'.
  Future<bool> registerDevice({
    required String token,
    required String platform,
  }) async {
    if (!AuthService.hasSession) {
      debugPrint('[PushApi] registerDevice: no session');
      return false;
    }

    final authToken = AuthService.session.token;
    if (authToken == null || authToken.isEmpty) {
      debugPrint('[PushApi] registerDevice: no auth token');
      return false;
    }

    final uri = ApiClient.buildUri('/devices/register');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $authToken',
    };

    try {
      debugPrint('[PushApi] POST $uri (platform: $platform)');
      // NOTE: Never log the device token
      final response = await ApiClient.client
          .post(
            uri,
            headers: headers,
            body: jsonEncode({
              'token': token,
              'platform': platform,
            }),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[PushApi] registerDevice: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // 409 = already registered (treat as success)
      if (response.statusCode == 409) {
        debugPrint('[PushApi] registerDevice: already registered (OK)');
        return true;
      }

      debugPrint('[PushApi] registerDevice: failed ${response.statusCode}');
      return false;
    } on TimeoutException {
      debugPrint('[PushApi] registerDevice: timeout');
      return false;
    } catch (e) {
      debugPrint('[PushApi] registerDevice: error $e');
      return false;
    }
  }

  /// Unregisters a device token.
  ///
  /// Calls `DELETE /devices/unregister` with Bearer token.
  ///
  /// [token] is the FCM device token to remove.
  Future<bool> unregisterDevice({required String token}) async {
    if (!AuthService.hasSession) {
      debugPrint('[PushApi] unregisterDevice: no session');
      return false;
    }

    final authToken = AuthService.session.token;
    if (authToken == null || authToken.isEmpty) {
      debugPrint('[PushApi] unregisterDevice: no auth token');
      return false;
    }

    final uri = ApiClient.buildUri('/devices/unregister');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $authToken',
    };

    try {
      debugPrint('[PushApi] DELETE $uri');
      final response = await ApiClient.client
          .delete(
            uri,
            headers: headers,
            body: jsonEncode({'token': token}),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[PushApi] unregisterDevice: ${response.statusCode}');

      return response.statusCode == 200 || response.statusCode == 204;
    } on TimeoutException {
      debugPrint('[PushApi] unregisterDevice: timeout');
      return false;
    } catch (e) {
      debugPrint('[PushApi] unregisterDevice: error $e');
      return false;
    }
  }
}

