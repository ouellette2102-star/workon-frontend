/// Notification preferences API for WorkOn.
///
/// **FL-NOTIF-PREFS:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../auth/auth_service.dart';
import '../auth/auth_errors.dart';
import 'notification_prefs_models.dart';

/// Exception thrown by [NotificationPrefsApi].
class NotificationPrefsApiException implements Exception {
  final String message;
  final int? statusCode;

  const NotificationPrefsApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'NotificationPrefsApiException: $message';
}

/// API client for notification preferences.
class NotificationPrefsApi {
  const NotificationPrefsApi();

  /// Gets all preferences for the current user.
  ///
  /// Calls `GET /api/v1/notifications/preferences`.
  Future<List<NotificationPreference>> getPreferences() async {
    debugPrint('[NotificationPrefsApi] Getting all preferences');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] getPreferences: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body);
      final List<dynamic> data;
      if (json is List) {
        data = json;
      } else if (json is Map<String, dynamic>) {
        data = json['preferences'] ?? json['data'] ?? [];
      } else {
        data = [];
      }

      return data
          .map((e) => NotificationPreference.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] getPreferences error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }

  /// Gets a specific preference.
  ///
  /// Calls `GET /api/v1/notifications/preferences/:type`.
  Future<NotificationPreference> getPreference(NotificationType type) async {
    debugPrint('[NotificationPrefsApi] Getting preference: ${type.value}');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences/${type.value}');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] getPreference: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['preference'] ?? json['data'] ?? json;
      return NotificationPreference.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] getPreference error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }

  /// Updates a preference.
  ///
  /// Calls `PUT /api/v1/notifications/preferences/:type`.
  Future<NotificationPreference> updatePreference(
    NotificationType type,
    UpdatePreferenceDto dto,
  ) async {
    debugPrint('[NotificationPrefsApi] Updating preference: ${type.value}');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences/${type.value}');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] PUT $uri');
      final response = await ApiClient.client
          .put(uri, headers: headers, body: jsonEncode(dto.toJson()))
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] updatePreference: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['preference'] ?? json['data'] ?? json;
      return NotificationPreference.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] updatePreference error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }

  /// Sets quiet hours.
  ///
  /// Calls `PUT /api/v1/notifications/preferences/quiet-hours`.
  Future<void> setQuietHours(SetQuietHoursDto dto) async {
    debugPrint('[NotificationPrefsApi] Setting quiet hours');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences/quiet-hours');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] PUT $uri');
      final response = await ApiClient.client
          .put(uri, headers: headers, body: jsonEncode(dto.toJson()))
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] setQuietHours: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] setQuietHours error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }

  /// Unsubscribes from marketing notifications.
  ///
  /// Calls `POST /api/v1/notifications/preferences/unsubscribe-marketing`.
  Future<void> unsubscribeFromMarketing() async {
    debugPrint('[NotificationPrefsApi] Unsubscribing from marketing');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences/unsubscribe-marketing');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] POST $uri');
      final response = await ApiClient.client
          .post(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] unsubscribeFromMarketing: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] unsubscribeFromMarketing error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }

  /// Initializes default preferences.
  ///
  /// Calls `POST /api/v1/notifications/preferences/initialize`.
  Future<void> initializeDefaults() async {
    debugPrint('[NotificationPrefsApi] Initializing defaults');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/notifications/preferences/initialize');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[NotificationPrefsApi] POST $uri');
      final response = await ApiClient.client
          .post(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[NotificationPrefsApi] initializeDefaults: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw NotificationPrefsApiException('Erreur ${response.statusCode}');
      }
    } on TimeoutException {
      throw const NotificationPrefsApiException('Connexion impossible');
    } on http.ClientException {
      throw const NotificationPrefsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is NotificationPrefsApiException || e is AuthException) rethrow;
      debugPrint('[NotificationPrefsApi] initializeDefaults error: $e');
      throw const NotificationPrefsApiException('Une erreur est survenue');
    }
  }
}
