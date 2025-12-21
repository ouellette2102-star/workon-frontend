/// Authentication service for WorkOn.
///
/// Provides a high-level API for user authentication including login,
/// registration, token validation, and logout.
///
/// **Architecture:**
/// - Uses [AuthRepository] abstraction for backend operations
/// - Manages in-memory session state
/// - Exposes typed errors for error handling
///
/// **Current State (PR#5):** Wired to [RealAuthRepository] (Railway backend).
/// **Tokens:** In-memory only (no SecureStorage yet).
library;

import 'auth_errors.dart';
import 'auth_models.dart';
import 'auth_repository.dart';
import 'real_auth_repository.dart';

/// Authentication service handling user login, registration, and session.
///
/// ## Usage
///
/// ```dart
/// // Initialize (typically done once at app startup)
/// AuthService.initialize();
///
/// // Login
/// final session = await AuthService.login(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// // Check authentication state
/// if (AuthService.isAuthenticated) {
///   print('Logged in as ${AuthService.currentUser?.email}');
/// }
///
/// // Logout
/// await AuthService.logout();
/// ```
///
/// ## Repository Pattern
///
/// This service delegates to an [AuthRepository] implementation:
/// - [RealAuthRepository]: Default, connects to Railway backend
/// - [MockAuthRepository]: For testing, returns mock data
abstract final class AuthService {
  // ─────────────────────────────────────────────────────────────────────────
  // Repository (Dependency Injection Point)
  // ─────────────────────────────────────────────────────────────────────────

  /// The repository used for authentication operations.
  ///
  /// Defaults to [RealAuthRepository] (PR#5).
  /// Use [initialize] to switch to [MockAuthRepository] for testing.
  static AuthRepository _repository = RealAuthRepository();

  /// Initializes the AuthService with a custom repository.
  ///
  /// Call this at app startup to inject dependencies:
  /// ```dart
  /// // For production (PR#5+):
  /// AuthService.initialize(
  ///   repository: RealAuthRepository(apiClient: ApiClient),
  /// );
  ///
  /// // For testing:
  /// AuthService.initialize(
  ///   repository: MockAuthRepository(),
  /// );
  /// ```
  static void initialize({AuthRepository? repository}) {
    if (repository != null) {
      _repository = repository;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Session State (In-Memory)
  // ─────────────────────────────────────────────────────────────────────────

  /// Current authentication session (null if not logged in).
  static AuthSession? _currentSession;

  /// Returns the current session, or null if not authenticated.
  static AuthSession? get currentSession => _currentSession;

  /// Returns `true` if a user is currently authenticated.
  static bool get isAuthenticated => _currentSession != null;

  /// Alias for [isAuthenticated] for backward compatibility.
  static bool get isLoggedIn => isAuthenticated;

  /// Returns the current user, or null if not authenticated.
  static AuthUser? get currentUser => _currentSession?.user;

  /// Returns the current tokens, or null if not authenticated.
  static AuthTokens? get currentTokens => _currentSession?.tokens;

  /// Returns the current access token, or null if not authenticated.
  static String? get accessToken => _currentSession?.tokens.accessToken;

  // ─────────────────────────────────────────────────────────────────────────
  // Authentication Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// Authenticates a user with email and password.
  ///
  /// Returns the authenticated [AuthUser] on success.
  /// Updates [currentSession], [currentUser], and [currentTokens].
  ///
  /// Throws:
  /// - [InvalidCredentialsException] if credentials are incorrect.
  /// - [AuthNetworkException] if connection fails.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await AuthService.login(
  ///     email: 'user@example.com',
  ///     password: 'password123',
  ///   );
  ///   print('Welcome, ${user.name}!');
  /// } on InvalidCredentialsException {
  ///   print('Wrong email or password');
  /// }
  /// ```
  static Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final session = await _repository.login(
      email: email,
      password: password,
    );

    _currentSession = session;
    return session.user;
  }

  /// Registers a new user account.
  ///
  /// Returns the newly created [AuthUser] on success.
  /// Automatically logs in the user (sets [currentSession]).
  ///
  /// Throws:
  /// - [EmailAlreadyInUseException] if email is already registered.
  /// - [AuthNetworkException] if connection fails.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await AuthService.register(
  ///     email: 'newuser@example.com',
  ///     password: 'securePassword123',
  ///     name: 'John Doe',
  ///   );
  ///   print('Account created for ${user.email}');
  /// } on EmailAlreadyInUseException {
  ///   print('This email is already registered');
  /// }
  /// ```
  static Future<AuthUser> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final session = await _repository.register(
      email: email,
      password: password,
      name: name,
    );

    _currentSession = session;
    return session.user;
  }

  /// Fetches the current user's profile using the stored access token.
  ///
  /// If [accessToken] is provided, uses that token instead of the stored one.
  /// Updates [currentUser] with the fetched data.
  ///
  /// Returns the [AuthUser] associated with the token.
  ///
  /// Throws:
  /// - [UnauthorizedException] if the token is invalid or expired.
  /// - [AuthException] if no token is available.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await AuthService.me();
  ///   print('Current user: ${user.email}');
  /// } on UnauthorizedException {
  ///   // Token expired, redirect to login
  /// }
  /// ```
  static Future<AuthUser> me({String? accessToken}) async {
    final token = accessToken ?? _currentSession?.tokens.accessToken;

    if (token == null) {
      throw const UnauthorizedException();
    }

    final user = await _repository.me(accessToken: token);

    // Update session user if we have an active session
    if (_currentSession != null) {
      _currentSession = AuthSession(
        user: user,
        tokens: _currentSession!.tokens,
      );
    }

    return user;
  }

  /// Logs out the current user and clears the session.
  ///
  /// This method:
  /// 1. Notifies the repository to invalidate server session (if applicable)
  /// 2. Clears local session state
  ///
  /// Always succeeds locally even if server logout fails (fire-and-forget).
  ///
  /// Example:
  /// ```dart
  /// await AuthService.logout();
  /// // User is now logged out
  /// assert(!AuthService.isAuthenticated);
  /// ```
  static Future<void> logout() async {
    final token = _currentSession?.tokens.accessToken;

    // Clear local session first (ensures logout even if network fails)
    _currentSession = null;

    // Attempt server logout (fire-and-forget)
    try {
      await _repository.logout(accessToken: token);
    } catch (_) {
      // Ignore errors - local logout is sufficient
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Session Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Restores a session from stored tokens.
  ///
  /// Use this at app startup to restore a previously authenticated session.
  /// Validates the token by calling [me] to ensure it's still valid.
  ///
  /// Returns `true` if session was restored successfully.
  /// Returns `false` if token is invalid or expired.
  ///
  /// TODO(PR#6): Integrate with secure storage:
  /// ```dart
  /// static Future<bool> restoreSession() async {
  ///   final storedTokens = await SecureStorage.getTokens();
  ///   if (storedTokens == null) return false;
  ///   // ... validate and restore
  /// }
  /// ```
  static Future<bool> restoreSession(AuthTokens tokens) async {
    try {
      final user = await _repository.me(accessToken: tokens.accessToken);
      _currentSession = AuthSession(user: user, tokens: tokens);
      return true;
    } on AuthException {
      _currentSession = null;
      return false;
    }
  }

  /// Clears all session state.
  ///
  /// Use for testing or forced logout without server notification.
  static void reset() {
    _currentSession = null;
  }

  /// Resets the repository to default [RealAuthRepository].
  ///
  /// Use after testing to restore production state.
  static void resetRepository() {
    _repository = RealAuthRepository();
    _currentSession = null;
  }

  /// Switches to mock repository for testing.
  ///
  /// Call this in test setup to avoid real API calls.
  static void useMockRepository() {
    _repository = MockAuthRepository();
    _currentSession = null;
  }
}
