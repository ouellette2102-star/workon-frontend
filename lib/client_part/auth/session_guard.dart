/// Session guard for handling 401 unauthorized responses.
///
/// Provides a centralized way to handle session expiration:
/// - Shows a snackbar with French message
/// - Clears local session via AuthService.logout()
/// - Navigates to login with stack reset
/// - Prevents double redirects when multiple calls fail
///
/// **PR-SESSION:** Initial implementation.
/// **PR-S2:** Added ConsentGuard for CONSENT_REQUIRED modal handling.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/auth/auth_service.dart';
import '/services/legal/consent_gate.dart';
import '/services/legal/consent_store.dart';
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

// ─────────────────────────────────────────────────────────────────────────────
// PR-S2: Consent Guard
// ─────────────────────────────────────────────────────────────────────────────

/// Handles CONSENT_REQUIRED (403) by showing a modal dialog.
///
/// Must be initialized at app startup with a BuildContext.
///
/// Usage:
/// ```dart
/// // At app startup (e.g., in main.dart or after first frame)
/// ConsentGuard.initialize(navigatorKey.currentContext!);
/// ```
abstract final class ConsentGuard {
  // ─────────────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────────────

  /// Global navigator key for showing dialogs without context.
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Whether initialized.
  static bool get isInitialized => _navigatorKey != null;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the consent guard with navigator key.
  ///
  /// Call this once at app startup, passing your MaterialApp's navigatorKey.
  ///
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  ///
  /// MaterialApp(
  ///   navigatorKey: navigatorKey,
  ///   ...
  /// );
  ///
  /// // After first frame
  /// WidgetsBinding.instance.addPostFrameCallback((_) {
  ///   ConsentGuard.initialize(navigatorKey);
  /// });
  /// ```
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;

    // Register callback with ConsentGate
    ConsentGate.setShowModalCallback(_showConsentModal);

    debugPrint('[ConsentGuard] Initialized');
  }

  /// Resets the guard (for testing).
  static void reset() {
    _navigatorKey = null;
    ConsentGate.reset();
    debugPrint('[ConsentGuard] Reset');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Modal Display
  // ─────────────────────────────────────────────────────────────────────────

  /// Shows the consent modal dialog.
  ///
  /// Returns true if user accepted, false if refused/closed.
  static Future<bool> _showConsentModal() async {
    final context = _navigatorKey?.currentContext;

    if (context == null) {
      debugPrint('[ConsentGuard] No valid context, cannot show modal');
      return false;
    }

    debugPrint('[ConsentGuard] Showing consent modal...');

    try {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Force user to make a choice
        builder: (dialogContext) => const _ConsentDialog(),
      );

      debugPrint('[ConsentGuard] Modal result: $result');
      return result ?? false;
    } catch (e) {
      debugPrint('[ConsentGuard] Modal error: $e');
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Consent Dialog Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Modal dialog for consent acceptance.
///
/// Shows:
/// - Title
/// - Summary of Terms & Privacy
/// - Links to full documents
/// - Accept / Decline buttons
class _ConsentDialog extends StatefulWidget {
  const _ConsentDialog();

  @override
  State<_ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<_ConsentDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Conditions d\'utilisation',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pour continuer à utiliser WorkOn, vous devez accepter nos conditions d\'utilisation et notre politique de confidentialité.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            // Terms link
            _buildLinkRow(
              icon: Icons.description_outlined,
              text: 'Conditions d\'utilisation',
              onTap: () => _openLegalPage('terms'),
            ),
            const SizedBox(height: 8),
            // Privacy link
            _buildLinkRow(
              icon: Icons.privacy_tip_outlined,
              text: 'Politique de confidentialité',
              onTap: () => _openLegalPage('privacy'),
            ),
            const SizedBox(height: 16),
            // Version info
            FutureBuilder<String?>(
              future: ConsentStore.getTermsVersion(),
              builder: (context, snapshot) {
                final version = snapshot.data ?? '—';
                return Text(
                  'Version: $version',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        // Decline button
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Refuser',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        // Accept button
        ElevatedButton(
          onPressed: _isLoading ? null : _handleAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('J\'accepte'),
        ),
      ],
    );
  }

  Widget _buildLinkRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                decoration: TextDecoration.underline,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.open_in_new,
              size: 16,
              color: Color(0xFF3B82F6),
            ),
          ],
        ),
      ),
    );
  }

  void _openLegalPage(String type) {
    debugPrint('[ConsentDialog] Opening $type page');

    if (type == 'terms') {
      context.pushNamed(TermsOfServiceWidget.routeName);
    } else {
      context.pushNamed(PrivacyPolicyWidget.routeName);
    }
  }

  Future<void> _handleAccept() async {
    setState(() => _isLoading = true);

    try {
      // The actual backend call will happen in ConsentGate.ensureAccepted()
      // after we return true from this dialog
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('[ConsentDialog] Accept error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'acceptation. Réessaie.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }
}
