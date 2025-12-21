/// Authentication bootstrap for WorkOn.
///
/// Provides lightweight session checking at app startup.
/// No exceptions bubble up - all errors return `false`.
///
/// **PR#6:** Initial implementation with in-memory session check.
library;

import 'auth_service.dart';

/// Authentication bootstrap utility.
///
/// Use this at app startup to check if a valid session exists.
///
/// ## Usage
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Check if user has valid session
///   final hasSession = await AuthBootstrap.checkSession();
///
///   runApp(MyApp(isAuthenticated: hasSession));
/// }
/// ```
///
/// ## Behavior
///
/// - Calls `AuthService.me()` to validate current session
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
  /// 3. Returns the result without throwing
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
    // Quick check: if no session exists, return false immediately
    if (!AuthService.isAuthenticated) {
      return false;
    }

    // Validate session with backend
    return AuthService.hasValidSession();
  }

  /// Initializes authentication and checks session in one call.
  ///
  /// Convenience method that combines initialization and session check.
  ///
  /// Example:
  /// ```dart
  /// final isLoggedIn = await AuthBootstrap.initialize();
  /// ```
  static Future<bool> initialize() async {
    // AuthService is already initialized with default repository
    // Just check if we have a valid session
    return checkSession();
  }
}

