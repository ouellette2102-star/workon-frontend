/// Session guard for handling 401 unauthorized responses.
///
/// Provides a centralized way to handle session expiration:
/// - Shows a snackbar with French message
/// - Clears local session via AuthService.logout()
/// - Navigates to login with stack reset
/// - Prevents double redirects when multiple calls fail
///
/// **PR-SESSION:** Initial implementation.
library;

import 'package:flutter/material.dart';
import '/services/auth/auth_service.dart';
import '/client_part/sign_in/sign_in_widget.dart';

/// Centralized session guard for handling unauthorized (401) responses.
///
/// Usage:
/// ```dart
/// try {
///   await someApiCall();
/// } on UnauthorizedException {
///   SessionGuard.handleUnauthorized(context);
/// }
/// ```
abstract final class SessionGuard {
  // ─────────────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────────────

  /// Flag to prevent multiple simultaneous redirects.
  static bool _isRedirecting = false;

  /// Getter for testing/debugging.
  static bool get isRedirecting => _isRedirecting;

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Handles an unauthorized (401) response.
  ///
  /// This method:
  /// 1. Shows a red snackbar with "Session expirée. Reconnecte-toi."
  /// 2. Clears the local session via [AuthService.logout()]
  /// 3. Navigates to the login screen, clearing the navigation stack
  ///
  /// **Double-redirect protection:** If multiple API calls return 401
  /// simultaneously, only the first call will trigger the redirect.
  /// Subsequent calls are ignored until the redirect completes.
  ///
  /// Parameters:
  /// - [context]: BuildContext for navigation and snackbar
  ///
  /// Returns immediately if:
  /// - Another redirect is already in progress
  /// - Context is no longer mounted
  static Future<void> handleUnauthorized(BuildContext context) async {
    // Guard: prevent double redirects
    if (_isRedirecting) {
      debugPrint('[SessionGuard] Already redirecting, skipping');
      return;
    }

    // Guard: check context is still valid
    if (!context.mounted) {
      debugPrint('[SessionGuard] Context not mounted, skipping');
      return;
    }

    debugPrint('[SessionGuard] Handling unauthorized - starting redirect');
    _isRedirecting = true;

    try {
      // 1. Show snackbar (before navigation so user sees it)
      _showSessionExpiredSnackbar(context);

      // 2. Clear local session (fire-and-forget, don't block navigation)
      _clearSession();

      // 3. Navigate to login with stack reset
      if (context.mounted) {
        await _navigateToLogin(context);
      }
    } finally {
      // Reset flag after navigation completes or fails
      _isRedirecting = false;
      debugPrint('[SessionGuard] Redirect completed');
    }
  }

  /// Resets the guard state.
  ///
  /// Useful for testing or recovery scenarios.
  static void reset() {
    _isRedirecting = false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Shows the session expired snackbar.
  static void _showSessionExpiredSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session expirée. Reconnecte-toi.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Clears the local session.
  static void _clearSession() {
    // Fire-and-forget logout to clear tokens
    AuthService.logout().catchError((e) {
      debugPrint('[SessionGuard] Logout error (ignored): $e');
    });
  }

  /// Navigates to the login screen, clearing the stack.
  static Future<void> _navigateToLogin(BuildContext context) async {
    // Use pushNamedAndRemoveUntil to clear the entire stack
    await Navigator.of(context).pushNamedAndRemoveUntil(
      SignInWidget.routePath,
      (route) => false, // Remove all routes
    );
  }
}

