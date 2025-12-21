/// Authentication repository abstraction for WorkOn.
///
/// Defines the contract for authentication operations, enabling
/// dependency injection and easy swapping between mock and real implementations.
///
/// **Current State (PR#4):** MockAuthRepository (in-memory, no network).
/// **Future State (PR#5):** RealAuthRepository using ApiClient.
library;

import '../api/api_client.dart';
import 'auth_errors.dart';
import 'auth_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Abstract Repository Interface
// ─────────────────────────────────────────────────────────────────────────────

/// Abstract interface for authentication operations.
///
/// Implementations must provide login, register, me, and logout functionality.
/// This abstraction allows swapping between mock and real implementations
/// without changing the AuthService consumer code.
abstract class AuthRepository {
  /// Authenticates a user with email and password.
  ///
  /// Returns an [AuthSession] containing user and tokens on success.
  ///
  /// Throws:
  /// - [InvalidCredentialsException] if credentials are incorrect.
  /// - [AuthNetworkException] if connection fails.
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  ///
  /// Returns an [AuthSession] containing user and tokens on success.
  ///
  /// Throws:
  /// - [EmailAlreadyInUseException] if email is already registered.
  /// - [AuthNetworkException] if connection fails.
  Future<AuthSession> register({
    required String email,
    required String password,
    String? name,
  });

  /// Fetches the current user's profile using an access token.
  ///
  /// Returns the [AuthUser] associated with the token.
  ///
  /// Throws:
  /// - [UnauthorizedException] if the token is invalid or expired.
  Future<AuthUser> me({required String accessToken});

  /// Logs out the current user.
  ///
  /// This should invalidate the session on the server if applicable.
  /// Local session cleanup is handled by AuthService.
  Future<void> logout({String? accessToken});
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock Implementation (In-Memory, No Network)
// ─────────────────────────────────────────────────────────────────────────────

/// Mock implementation of [AuthRepository] for development and testing.
///
/// Returns deterministic mock data without making any network calls.
/// This implementation is safe to use even when the backend is unavailable.
///
/// TODO(PR#5): Replace with [RealAuthRepository] that uses [ApiClient].
class MockAuthRepository implements AuthRepository {
  /// Creates a [MockAuthRepository].
  ///
  /// The [apiClient] parameter is accepted for interface compatibility
  /// but is NOT used in this mock implementation.
  MockAuthRepository({ApiClient? apiClient}) : _apiClient = apiClient;

  // ignore: unused_field - Reserved for future RealAuthRepository
  final ApiClient? _apiClient;

  // Mock constants for deterministic testing
  static const String _mockUserId = 'usr_mock_001';
  static const String _mockAccessToken = 'mock_access_token_abc123';
  static const String _mockRefreshToken = 'mock_refresh_token_xyz789';

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw const InvalidCredentialsException();
    }

    // Mock: reject specific test credentials
    if (email == 'invalid@test.com') {
      throw const InvalidCredentialsException();
    }

    // Return mock session
    return AuthSession(
      user: AuthUser(
        id: _mockUserId,
        email: email,
        name: _extractNameFromEmail(email),
      ),
      tokens: AuthTokens(
        accessToken: _mockAccessToken,
        refreshToken: _mockRefreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    );
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? name,
  }) async {
    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required');
    }

    // Mock: reject specific test email as "already in use"
    if (email == 'taken@test.com') {
      throw const EmailAlreadyInUseException();
    }

    // Return mock session
    return AuthSession(
      user: AuthUser(
        id: _mockUserId,
        email: email,
        name: name ?? _extractNameFromEmail(email),
      ),
      tokens: AuthTokens(
        accessToken: _mockAccessToken,
        refreshToken: _mockRefreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    );
  }

  @override
  Future<AuthUser> me({required String accessToken}) async {
    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Mock validation
    if (accessToken.isEmpty || accessToken == 'invalid_token') {
      throw const UnauthorizedException();
    }

    // Return deterministic mock user
    return const AuthUser(
      id: _mockUserId,
      email: 'user@workon.app',
      name: 'WorkOn User',
    );
  }

  @override
  Future<void> logout({String? accessToken}) async {
    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Mock: always succeeds (fire-and-forget pattern)
    // No-op since we don't have a real server session to invalidate
  }

  /// Extracts a display name from an email address.
  static String _extractNameFromEmail(String email) {
    final localPart = email.split('@').first;
    return localPart
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Real Implementation Stub (For Future PR#5)
// ─────────────────────────────────────────────────────────────────────────────

/// TODO(PR#5): Implement RealAuthRepository
///
/// ```dart
/// class RealAuthRepository implements AuthRepository {
///   RealAuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;
///
///   final ApiClient _apiClient;
///
///   @override
///   Future<AuthSession> login({required String email, required String password}) async {
///     final uri = ApiClient.buildUri('/auth/login');
///     final response = await _apiClient.client.post(
///       uri,
///       headers: ApiClient.defaultHeaders,
///       body: jsonEncode({'email': email, 'password': password}),
///     );
///
///     if (response.statusCode == 401) {
///       throw const InvalidCredentialsException();
///     }
///     if (response.statusCode != 200) {
///       throw const AuthNetworkException();
///     }
///
///     return AuthSession.fromJson(jsonDecode(response.body));
///   }
///
///   // ... other methods
/// }
/// ```

