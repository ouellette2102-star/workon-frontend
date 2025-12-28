/// Authentication bootstrap for WorkOn.
///
/// Provides lightweight session checking at app startup.
/// No exceptions bubble up - all errors return `false`.
///
/// **PR#6:** Initial implementation with in-memory session check.
/// **PR#7:** Updated to use refreshAuthState() for state synchronization.
/// **PR-F04:** Now restores session from persistent storage.
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
/// - Attempts to restore session from persistent storage (PR-F04)
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
  /// 1. Attempts to restore session from storage (PR-F04)
  /// 2. Checks if there's a stored session in AuthService
  /// 3. Validates the session by calling /auth/me
  /// 4. Updates [AuthService.state] via [AuthService.refreshAuthState] (PR#7)
  /// 5. Returns the result without throwing
  ///
  /// Returns `true` if:
  /// - A valid session exists (in-memory or restored from storage)
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
    // PR-F04: First try to restore session from persistent storage
    if (!AuthService.isAuthenticated) {
      final restored = await AuthService.tryRestoreSession();
      if (restored) {
        return true;
      }
    }

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
  /// Now also restores session from persistent storage (PR-F04).
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

