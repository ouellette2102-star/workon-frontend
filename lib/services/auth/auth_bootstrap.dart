/// Authentication bootstrap for WorkOn.
///
/// Provides lightweight session checking at app startup.
/// No exceptions bubble up - all errors return `false`.
///
/// **PR#6:** Initial implementation with in-memory session check.
/// **PR#7:** Updated to use refreshAuthState() for state synchronization.
library;

import 'auth_service.dart';
import 'auth_state.dart';

/// Authentication bootstrap utility.
///
/// Use this at app startup to check if a valid session exists
/// and synchronize the auth state.
///
/// ## Usage
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Check if user has valid session and update auth state
///   final hasSession = await AuthBootstrap.checkSession();
///
///   runApp(MyApp(isAuthenticated: hasSession));
/// }
/// ```
///
/// ## Behavior
///
/// - Validates the current session with backend
/// - Updates [AuthService.state] accordingly (PR#7)
/// - Returns `true` if session is valid
/// - Returns `false` on any error (network, auth, etc.)
/// - Never throws exceptions
/// - No logging noise
abstract final class AuthBootstrap {
  /// Checks if a valid authentication session exists.
  ///
  /// This method:
  /// 1. Checks if there's a stored session in AuthService
  /// 2. Validates the session by calling /auth/me
  /// 3. Updates [AuthService.state] via [AuthService.refreshAuthState] (PR#7)
  /// 4. Returns the result without throwing
  ///
  /// Returns `true` if:
  /// - A valid session exists
  /// - The backend confirms the token is valid
  ///
  /// Returns `false` if:
  /// - No session exists
  /// - Token is expired or invalid
  /// - Network error occurs
  /// - Any other error occurs
  ///
  /// Example:
  /// ```dart
  /// final isLoggedIn = await AuthBootstrap.checkSession();
  /// if (isLoggedIn) {
  ///   // Navigate to home
  /// } else {
  ///   // Navigate to login
  /// }
  /// ```
  static Future<bool> checkSession() async {
    // Quick check: if no session exists, set unauthenticated and return
    if (!AuthService.isAuthenticated) {
      AuthService.setAuthState(const AuthState.unauthenticated());
      return false;
    }

    // PR#7: Use refreshAuthState which validates and updates state
    return AuthService.refreshAuthState();
  }

  /// Initializes authentication and checks session in one call.
  ///
  /// Convenience method that combines initialization and session check.
  /// Also updates [AuthService.state] (PR#7).
  ///
  /// Example:
  /// ```dart
  /// final isLoggedIn = await AuthBootstrap.initialize();
  /// // AuthService.state is now authenticated or unauthenticated
  /// ```
  static Future<bool> initialize() async {
    // AuthService is already initialized with default repository
    // Check session and update auth state
    return checkSession();
  }
}

