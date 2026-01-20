/// Legal consent gate for WorkOn.
///
/// Wraps child widgets and shows [LegalConsentWidget] if consent is required.
/// Integrated with [ConsentStore] for persistence and backend sync.
///
/// **PR-V1-01:** Store-ready legal consent gate.
library;

import 'package:flutter/material.dart';

import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/auth/auth_service.dart';
import '/services/legal/consent_store.dart';
import 'legal_consent_widget.dart';

/// Gate widget that checks for legal consent before showing child.
///
/// ## Usage
///
/// Wrap your authenticated content:
/// ```dart
/// LegalConsentGate(
///   child: HomeWidget(),
/// )
/// ```
///
/// The gate will:
/// 1. Show loading while checking consent status
/// 2. Show [LegalConsentWidget] if consent required
/// 3. Show child widget if consent already given
class LegalConsentGate extends StatefulWidget {
  const LegalConsentGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LegalConsentGate> createState() => _LegalConsentGateState();
}

class _LegalConsentGateState extends State<LegalConsentGate> {
  bool _isLoading = true;
  bool _hasConsent = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Initialize consent store
      await ConsentStore.initialize();

      // Check local consent first (fast)
      final localConsent = await ConsentStore.hasConsented();
      debugPrint('[LegalConsentGate] Local consent: $localConsent');

      if (localConsent) {
        // User has consented locally, show content immediately
        if (mounted) {
          setState(() {
            _hasConsent = true;
            _isLoading = false;
          });
        }
        
        // Sync with backend in background (non-blocking)
        // This will update local cache if backend has newer terms
        _syncInBackground();
        return;
      }

      // No local consent, try to sync from backend
      // Only if user is authenticated
      if (AuthService.hasSession) {
        try {
          final syncResult = await ConsentStore.syncFromBackend();
          debugPrint('[LegalConsentGate] Backend sync result: $syncResult');
          
          if (mounted) {
            setState(() {
              _hasConsent = syncResult;
              _isLoading = false;
            });
          }
        } catch (e) {
          debugPrint('[LegalConsentGate] Backend sync failed: $e');
          // Backend sync failed, show consent screen
          if (mounted) {
            setState(() {
              _hasConsent = false;
              _isLoading = false;
            });
          }
        }
      } else {
        // Not authenticated, show content (consent will be required after login)
        if (mounted) {
          setState(() {
            _hasConsent = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('[LegalConsentGate] Error checking consent: $e');
      // On error, show consent screen to be safe
      if (mounted) {
        setState(() {
          _hasConsent = false;
          _isLoading = false;
        });
      }
    }
  }

  /// Background sync with backend (non-blocking).
  Future<void> _syncInBackground() async {
    if (!AuthService.hasSession) return;

    try {
      final syncResult = await ConsentStore.syncFromBackend();
      
      // If backend says consent is not complete, show consent screen
      if (!syncResult && mounted) {
        setState(() {
          _hasConsent = false;
        });
      }
    } catch (e) {
      debugPrint('[LegalConsentGate] Background sync failed: $e');
      // Ignore background sync errors
    }
  }

  void _onConsentAccepted() {
    setState(() {
      _hasConsent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen(context);
    }

    if (!_hasConsent) {
      return LegalConsentWidget(
        isModal: true,
        onConsentAccepted: _onConsentAccepted,
      );
    }

    return widget.child;
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(WkRadius.xl),
              child: Image.asset(
                'assets/images/Sparkly_Logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: WkSpacing.xxl),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Static helper for showing consent modal from anywhere.
///
/// Usage:
/// ```dart
/// final accepted = await LegalConsentModal.show(context);
/// if (accepted) {
///   // Proceed
/// }
/// ```
abstract final class LegalConsentModal {
  /// Shows a modal bottom sheet with legal consent.
  ///
  /// Returns true if user accepted, false if cancelled.
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(WkRadius.xxl),
            ),
          ),
          child: LegalConsentWidget(
            isModal: true,
            onConsentAccepted: () => Navigator.of(context).pop(true),
          ),
        ),
      ),
    );

    return result ?? false;
  }
}

