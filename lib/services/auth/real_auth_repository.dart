/// Real authentication repository for WorkOn.
///
/// Implements [AuthRepository] with actual HTTP calls to the WorkOn
/// backend hosted on Railway.
///
/// **PR#5:** Initial implementation with login/register/me/logout.
/// **Tokens:** Stored in-memory only (no SecureStorage yet).
/// **No interceptors:** No automatic token refresh.
library;

import 'dart:convert';

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

      return _handleAuthResponse(response, 'login');
    } on http.ClientException {
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
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

      return _handleAuthResponse(response, 'register');
    } on http.ClientException {
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw const AuthNetworkException();
    }
  }

  @override
  Future<AuthUser> me({required String accessToken}) async {
    final uri = ApiClient.buildUri('/auth/me');

    try {
      final response = await ApiClient.client
          .get(
            uri,
            headers: {
              ...ApiClient.defaultHeaders,
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiClient.connectionTimeout);

      if (response.statusCode == 401) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw const AuthNetworkException();
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Handle both wrapped and unwrapped responses
      final userData = json['user'] ?? json['data'] ?? json;
      return AuthUser.fromJson(userData as Map<String, dynamic>);
    } on http.ClientException {
      throw const AuthNetworkException();
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw const AuthNetworkException();
    }
  }

  @override
  Future<void> logout({String? accessToken}) async {
    // If no token, nothing to invalidate on server
    if (accessToken == null) return;

    final uri = ApiClient.buildUri('/auth/logout');

    try {
      await ApiClient.client
          .post(
            uri,
            headers: {
              ...ApiClient.defaultHeaders,
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiClient.connectionTimeout);

      // Fire-and-forget: we don't care about the response
      // Local session cleanup is handled by AuthService
    } catch (_) {
      // Ignore all errors - logout should always succeed locally
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

