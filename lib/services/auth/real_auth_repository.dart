/// Real authentication repository for WorkOn.
///
/// Implements [AuthRepository] with actual HTTP calls to the WorkOn
/// backend hosted on Railway.
///
/// **PR#5:** Initial implementation with login/register/me/logout.
/// **PR#13:** Added debugPrint logging for error tracing.
/// **Tokens:** Stored in-memory only (no SecureStorage yet).
/// **No interceptors:** No automatic token refresh.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import 'auth_errors.dart';
import 'auth_models.dart';
import 'auth_repository.dart';

/// Real implementation of [AuthRepository] using HTTP calls.
///
/// Connects to the WorkOn backend API for authentication operations.
///
/// ## Usage
///
/// ```dart
/// final repository = RealAuthRepository();
/// final session = await repository.login(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// ```
///
/// ## Error Handling
///
/// All methods throw typed [AuthException] subclasses:
/// - [InvalidCredentialsException]: 401 on login
/// - [EmailAlreadyInUseException]: 409 on register
/// - [UnauthorizedException]: 401 on me/logout
/// - [AuthNetworkException]: Network or server errors
class RealAuthRepository implements AuthRepository {
  /// Creates a [RealAuthRepository].
  ///
  /// Uses the shared [ApiClient] for HTTP configuration.
  RealAuthRepository();

  // ─────────────────────────────────────────────────────────────────────────
  // Authentication Endpoints
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final uri = ApiClient.buildUri('/auth/login');

    try {
      debugPrint('[RealAuthRepository] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: ApiClient.defaultHeaders,
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] login response: ${response.statusCode}');
      return _handleAuthResponse(response, 'login');
    } on TimeoutException {
      debugPrint('[RealAuthRepository] login timeout');
      throw const AuthNetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      debugPrint('[RealAuthRepository] login network error: $e');
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('[RealAuthRepository] login unexpected error: $e');
      throw const AuthNetworkException();
    }
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final uri = ApiClient.buildUri('/auth/register');

    try {
      debugPrint('[RealAuthRepository] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: ApiClient.defaultHeaders,
            body: jsonEncode({
              'email': email,
              'password': password,
              if (name != null) 'name': name,
            }),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] register response: ${response.statusCode}');
      return _handleAuthResponse(response, 'register');
    } on TimeoutException {
      debugPrint('[RealAuthRepository] register timeout');
      throw const AuthNetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      debugPrint('[RealAuthRepository] register network error: $e');
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('[RealAuthRepository] register unexpected error: $e');
      throw const AuthNetworkException();
    }
  }

  @override
  Future<AuthUser> me({required String accessToken}) async {
    final uri = ApiClient.buildUri('/auth/me');

    try {
      debugPrint('[RealAuthRepository] GET $uri');
      final response = await ApiClient.client
          .get(
            uri,
            headers: {
              ...ApiClient.defaultHeaders,
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] me response: ${response.statusCode}');

      if (response.statusCode == 401) {
        debugPrint('[RealAuthRepository] me: unauthorized');
        throw const UnauthorizedException();
      }

      if (response.statusCode == 403) {
        debugPrint('[RealAuthRepository] me: forbidden');
        throw const UnauthorizedException();
      }

      if (response.statusCode >= 500) {
        debugPrint('[RealAuthRepository] me: server error ${response.statusCode}');
        throw const AuthNetworkException('Server error');
      }

      if (response.statusCode != 200) {
        debugPrint('[RealAuthRepository] me: unexpected status ${response.statusCode}');
        throw const AuthNetworkException();
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Handle both wrapped and unwrapped responses
      final userData = json['user'] ?? json['data'] ?? json;
      return AuthUser.fromJson(userData as Map<String, dynamic>);
    } on TimeoutException {
      debugPrint('[RealAuthRepository] me timeout');
      throw const AuthNetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      debugPrint('[RealAuthRepository] me network error: $e');
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('[RealAuthRepository] me unexpected error: $e');
      throw const AuthNetworkException();
    }
  }

  @override
  Future<void> logout({String? accessToken}) async {
    // If no token, nothing to invalidate on server
    if (accessToken == null) {
      debugPrint('[RealAuthRepository] logout: no token, skipping server call');
      return;
    }

    final uri = ApiClient.buildUri('/auth/logout');

    try {
      debugPrint('[RealAuthRepository] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: {
              ...ApiClient.defaultHeaders,
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] logout response: ${response.statusCode}');
      // Fire-and-forget: we don't care about the response
      // Local session cleanup is handled by AuthService
    } catch (e) {
      // Ignore all errors - logout should always succeed locally
      debugPrint('[RealAuthRepository] logout error (ignored): $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-F14: Password Reset Endpoints
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<void> forgotPassword({required String email}) async {
    final uri = ApiClient.buildUri('/auth/forgot-password');

    try {
      debugPrint('[RealAuthRepository] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: ApiClient.defaultHeaders,
            body: jsonEncode({'email': email.trim()}),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] forgotPassword response: ${response.statusCode}');

      switch (response.statusCode) {
        case 200:
        case 201:
        case 204:
          // Success - email sent
          return;

        case 400:
          final message = _extractErrorMessage(response.body);
          throw AuthException(message ?? 'Adresse email invalide');

        case 404:
          throw const AuthException('Aucun compte associé à cet email');

        case 429:
          throw const AuthException('Trop de tentatives. Réessaie plus tard.');

        default:
          throw const AuthNetworkException();
      }
    } on TimeoutException {
      debugPrint('[RealAuthRepository] forgotPassword timeout');
      throw const AuthNetworkException('Délai de connexion dépassé');
    } on http.ClientException catch (e) {
      debugPrint('[RealAuthRepository] forgotPassword network error: $e');
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('[RealAuthRepository] forgotPassword unexpected error: $e');
      throw const AuthNetworkException();
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final uri = ApiClient.buildUri('/auth/reset-password');

    try {
      debugPrint('[RealAuthRepository] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: ApiClient.defaultHeaders,
            body: jsonEncode({
              'email': email.trim(),
              'code': code.trim(),
              'newPassword': newPassword,
            }),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[RealAuthRepository] resetPassword response: ${response.statusCode}');

      switch (response.statusCode) {
        case 200:
        case 201:
        case 204:
          // Success - password reset
          return;

        case 400:
          final message = _extractErrorMessage(response.body);
          throw AuthException(message ?? 'Code invalide ou expiré');

        case 401:
          throw const AuthException('Code invalide ou expiré');

        case 422:
          final message = _extractErrorMessage(response.body);
          throw AuthException(message ?? 'Mot de passe invalide');

        case 429:
          throw const AuthException('Trop de tentatives. Réessaie plus tard.');

        default:
          throw const AuthNetworkException();
      }
    } on TimeoutException {
      debugPrint('[RealAuthRepository] resetPassword timeout');
      throw const AuthNetworkException('Délai de connexion dépassé');
    } on http.ClientException catch (e) {
      debugPrint('[RealAuthRepository] resetPassword network error: $e');
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('[RealAuthRepository] resetPassword unexpected error: $e');
      throw const AuthNetworkException();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Response Handling
  // ─────────────────────────────────────────────────────────────────────────

  /// Handles authentication responses (login/register).
  ///
  /// Parses the response body and returns an [AuthSession].
  /// Throws typed exceptions based on status code.
  AuthSession _handleAuthResponse(http.Response response, String operation) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return _parseAuthSession(response.body);

      case 400:
        // Bad request - validation error
        final message = _extractErrorMessage(response.body);
        throw AuthException(message ?? 'Invalid request');

      case 401:
        // Unauthorized - invalid credentials
        throw const InvalidCredentialsException();

      case 409:
        // Conflict - email already in use (register only)
        throw const EmailAlreadyInUseException();

      case 422:
        // Unprocessable entity - validation error
        final message = _extractErrorMessage(response.body);
        throw AuthException(message ?? 'Validation failed');

      case 429:
        // Too many requests
        throw const AuthException('Too many attempts. Please try again later');

      case 500:
      case 502:
      case 503:
      case 504:
        // Server error
        throw const AuthNetworkException();

      default:
        throw const AuthNetworkException();
    }
  }

  /// Parses the response body into an [AuthSession].
  ///
  /// Handles various backend response formats:
  /// - `{ user: {...}, tokens: {...} }`
  /// - `{ user: {...}, access_token: "...", refresh_token: "..." }`
  /// - `{ data: { user: {...}, tokens: {...} } }`
  AuthSession _parseAuthSession(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;

      // Try standard format first
      if (json.containsKey('user') && json.containsKey('tokens')) {
        return AuthSession.fromJson(json);
      }

      // Try wrapped format
      if (json.containsKey('data')) {
        final data = json['data'] as Map<String, dynamic>;
        return AuthSession.fromJson(data);
      }

      // Try flat token format
      if (json.containsKey('user') && json.containsKey('access_token')) {
        return AuthSession(
          user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
          tokens: AuthTokens(
            accessToken: json['access_token'] as String,
            refreshToken: json['refresh_token'] as String? ?? '',
            expiresAt: json['expires_at'] != null
                ? DateTime.parse(json['expires_at'] as String)
                : null,
          ),
        );
      }

      // Fallback: try to parse as AuthSession directly
      return AuthSession.fromJson(json);
    } catch (e) {
      throw const AuthException('Failed to parse authentication response');
    }
  }

  /// Extracts error message from response body.
  String? _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String? ??
          json['error'] as String? ??
          json['errors']?.toString();
    } catch (_) {
      return null;
    }
  }
}

