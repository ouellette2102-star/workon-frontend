/// User API client for WorkOn.
///
/// Provides minimal API calls for user profile data.
///
/// **PR#12:** Initial implementation for role resolution.
/// **PR#13:** Added debugPrint logging and improved error handling.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
      debugPrint('[UserApi] fetchMe: no active session');
      throw const UserApiException('No active session');
    }

    // Get token from session
    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[UserApi] fetchMe: no token available');
      throw const UserApiException('No token available');
    }

    // Build request
    final uri = ApiClient.buildUri('/auth/me');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[UserApi] GET $uri');
      // Make request with timeout
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[UserApi] fetchMe response: ${response.statusCode}');

      // Check response
      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('[UserApi] fetchMe: unauthorized/forbidden');
        throw UserApiException('Unauthorized: ${response.statusCode}');
      }

      if (response.statusCode >= 500) {
        debugPrint('[UserApi] fetchMe: server error ${response.statusCode}');
        throw UserApiException('Server error: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        debugPrint('[UserApi] fetchMe: unexpected status ${response.statusCode}');
        throw UserApiException(
          'Failed to fetch profile: ${response.statusCode}',
        );
      }

      // Parse and return JSON
      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic>) {
        debugPrint('[UserApi] fetchMe: invalid response format');
        throw const UserApiException('Invalid response format');
      }

      return body;
    } on TimeoutException {
      debugPrint('[UserApi] fetchMe: timeout');
      throw const UserApiException('Connection timeout');
    } on UserApiException {
      rethrow;
    } catch (e) {
      debugPrint('[UserApi] fetchMe: unexpected error: $e');
      throw UserApiException('Network error: $e');
    }
  }

  /// Updates the current user's profile.
  ///
  /// Uses `PATCH /users/me` endpoint with Bearer token authentication.
  ///
  /// Only sends non-null fields (partial update).
  ///
  /// Returns the updated profile as a Map.
  ///
  /// Throws if:
  /// - No session exists
  /// - No token available
  /// - Network error occurs
  /// - Non-200 response
  Future<Map<String, dynamic>> patchMe({
    String? fullName,
    String? phone,
    String? city,
    String? bio,
    String? gender,
  }) async {
    // Check if we have a valid session
    if (!AuthService.hasSession) {
      debugPrint('[UserApi] patchMe: no active session');
      throw const UserApiException('No active session');
    }

    // Get token from session
    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[UserApi] patchMe: no token available');
      throw const UserApiException('No token available');
    }

    // Build request body (only non-null fields)
    final body = <String, dynamic>{};
    if (fullName != null) body['fullName'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (city != null) body['city'] = city;
    if (bio != null) body['bio'] = bio;
    if (gender != null) body['gender'] = gender;

    if (body.isEmpty) {
      debugPrint('[UserApi] patchMe: no fields to update');
      throw const UserApiException('No fields to update');
    }

    // Build request
    final uri = ApiClient.buildUri('/users/me');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[UserApi] PATCH $uri');
      // Make request with timeout
      final response = await ApiClient.client
          .patch(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[UserApi] patchMe response: ${response.statusCode}');

      // Check response
      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('[UserApi] patchMe: unauthorized/forbidden');
        throw UserApiException('Unauthorized: ${response.statusCode}');
      }

      if (response.statusCode >= 500) {
        debugPrint('[UserApi] patchMe: server error ${response.statusCode}');
        throw UserApiException('Server error: ${response.statusCode}');
      }

      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint('[UserApi] patchMe: unexpected status ${response.statusCode}');
        throw UserApiException(
          'Failed to update profile: ${response.statusCode}',
        );
      }

      // Parse and return JSON (or empty map for 204)
      if (response.statusCode == 204 || response.body.isEmpty) {
        return body; // Return what we sent
      }

      final responseBody = jsonDecode(response.body);
      if (responseBody is! Map<String, dynamic>) {
        debugPrint('[UserApi] patchMe: invalid response format');
        throw const UserApiException('Invalid response format');
      }

      return responseBody;
    } on TimeoutException {
      debugPrint('[UserApi] patchMe: timeout');
      throw const UserApiException('Connection timeout');
    } on UserApiException {
      rethrow;
    } catch (e) {
      debugPrint('[UserApi] patchMe: unexpected error: $e');
      throw UserApiException('Network error: $e');
    }
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

