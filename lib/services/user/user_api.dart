/// User API client for WorkOn.
///
/// Provides minimal API calls for user profile data.
///
/// **PR#12:** Initial implementation for role resolution.
library;

import 'dart:convert';

import '../api/api_client.dart';
import '../auth/auth_service.dart';

/// Minimal API client for user-related endpoints.
///
/// Uses existing [ApiClient] infrastructure and [AuthService.session]
/// for authentication.
///
/// ## Usage
///
/// ```dart
/// final api = UserApi();
/// final profile = await api.fetchMe();
/// print('Role: ${profile['role']}');
/// ```
class UserApi {
  /// Creates a [UserApi] instance.
  const UserApi();

  /// Fetches the current user's profile from the backend.
  ///
  /// Uses `GET /auth/me` endpoint with Bearer token authentication.
  ///
  /// Returns the parsed JSON response as a Map.
  ///
  /// Throws if:
  /// - No session exists
  /// - No token available
  /// - Network error occurs
  /// - Non-200 response
  ///
  /// Example:
  /// ```dart
  /// final profile = await UserApi().fetchMe();
  /// final role = profile['role'] as String?;
  /// ```
  Future<Map<String, dynamic>> fetchMe() async {
    // Check if we have a valid session
    if (!AuthService.hasSession) {
      throw const UserApiException('No active session');
    }

    // Get token from session
    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UserApiException('No token available');
    }

    // Build request
    final uri = ApiClient.buildUri('/auth/me');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    // Make request with timeout
    final response = await ApiClient.client
        .get(uri, headers: headers)
        .timeout(ApiClient.connectionTimeout);

    // Check response
    if (response.statusCode != 200) {
      throw UserApiException(
        'Failed to fetch profile: ${response.statusCode}',
      );
    }

    // Parse and return JSON
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const UserApiException('Invalid response format');
    }

    return body;
  }
}

/// Exception thrown by [UserApi] operations.
class UserApiException implements Exception {
  /// Creates a [UserApiException] with the given message.
  const UserApiException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'UserApiException: $message';
}

