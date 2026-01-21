/// Deep link error screen for WorkOn.
///
/// Displays a friendly error message when a deep link points to
/// invalid or unavailable content.
///
/// **PR-21:** Deep links error handling.
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

/// Error types for deep links.
enum DeepLinkErrorType {
  missionNotFound,
  profileNotFound,
  invalidLink,
  networkError,
}

/// Error screen displayed when a deep link fails.
///
/// Provides a friendly error message and option to go back to home.
class DeepLinkErrorWidget extends StatelessWidget {
  const DeepLinkErrorWidget({
    super.key,
    this.errorType = DeepLinkErrorType.invalidLink,
    this.resourceId,
  });

  /// Type of error that occurred.
  final DeepLinkErrorType errorType;

  /// Optional ID of the resource that was not found.
  final String? resourceId;

  static String routeName = 'DeepLinkError';
  static String routePath = '/link-error';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(),
                    size: 50,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _getTitle(),
                  style: theme.headlineMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  _getDescription(),
                  style: theme.bodyLarge.override(
                    fontFamily: 'General Sans',
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Go Home button
                SizedBox(
                  width: double.infinity,
                  child: FFButtonWidget(
                    onPressed: () => _goToHome(context),
                    text: 'Retour à l\'accueil',
                    options: FFButtonOptions(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      color: theme.primary,
                      textStyle: theme.titleSmall.override(
                        fontFamily: 'General Sans',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Back button (if can pop)
                if (Navigator.canPop(context))
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Retour',
                      style: theme.bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: theme.primary,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (errorType) {
      case DeepLinkErrorType.missionNotFound:
        return Icons.work_off_outlined;
      case DeepLinkErrorType.profileNotFound:
        return Icons.person_off_outlined;
      case DeepLinkErrorType.networkError:
        return Icons.wifi_off_outlined;
      case DeepLinkErrorType.invalidLink:
        return Icons.link_off;
    }
  }

  String _getTitle() {
    switch (errorType) {
      case DeepLinkErrorType.missionNotFound:
        return 'Mission introuvable';
      case DeepLinkErrorType.profileNotFound:
        return 'Profil introuvable';
      case DeepLinkErrorType.networkError:
        return 'Erreur de connexion';
      case DeepLinkErrorType.invalidLink:
        return 'Lien invalide';
    }
  }

  String _getDescription() {
    switch (errorType) {
      case DeepLinkErrorType.missionNotFound:
        return 'Cette mission n\'existe plus ou a été supprimée. Elle a peut-être déjà été complétée.';
      case DeepLinkErrorType.profileNotFound:
        return 'Ce profil n\'est plus disponible ou n\'existe pas.';
      case DeepLinkErrorType.networkError:
        return 'Impossible de charger le contenu. Vérifie ta connexion internet et réessaie.';
      case DeepLinkErrorType.invalidLink:
        return 'Ce lien ne semble pas être valide. Il a peut-être expiré ou est incorrect.';
    }
  }

  void _goToHome(BuildContext context) {
    // Clear navigation stack and go to home
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

