/// Social OAuth buttons with "Coming Soon" feedback.
///
/// PR-FIX-01: Ces boutons affichent un message "Bientôt disponible"
/// au lieu de crasher silencieusement.
///
/// Usage:
/// ```dart
/// SocialAuthButtonsWidget()
/// ```
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/config/ui_tokens.dart';

/// Social auth buttons row (Google, Apple, Facebook).
///
/// All buttons show a "Coming Soon" snackbar when tapped.
class SocialAuthButtonsWidget extends StatelessWidget {
  const SocialAuthButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google
        Expanded(
          child: _SocialButton(
            onTap: () => _showComingSoon(context, 'Google'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.asset(
                'assets/images/Google.png',
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        // Apple
        Expanded(
          child: _SocialButton(
            onTap: () => _showComingSoon(context, 'Apple'),
            child: Icon(
              Icons.apple_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 25.0,
            ),
          ),
        ),
        const SizedBox(width: 15),
        // Facebook
        Expanded(
          child: _SocialButton(
            onTap: () => _showComingSoon(context, 'Facebook'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.asset(
                'assets/images/Facebook.png',
                width: 28.0,
                height: 28.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows a "Coming Soon" snackbar.
  void _showComingSoon(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: WkIconSize.md),
            const SizedBox(width: WkSpacing.sm),
            Text('Connexion $provider bientôt disponible'),
          ],
        ),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WkRadius.button),
        ),
        margin: const EdgeInsets.all(WkSpacing.lg),
      ),
    );
  }
}

/// Individual social button with consistent styling.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 0.5,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

