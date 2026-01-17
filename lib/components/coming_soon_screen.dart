/// Coming Soon screen for features not yet available.
///
/// **PR-15:** Displays a polished "Coming Soon" message for template-only
/// screens that are not yet supported by the backend.
library;

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A premium "Coming Soon" screen that replaces dead-end template screens.
///
/// Usage:
/// - Redirect routes like VideoCall, VoiceCall, Bookings to this screen.
/// - Provides a non-blocking UX with back navigation.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    this.featureName,
  });

  /// Optional name of the feature (e.g., "Appels vidéo").
  final String? featureName;

  static String routeName = 'ComingSoon';
  static String routePath = '/comingSoon';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rocket icon with glow effect
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 72,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  'Bientôt disponible',
                  style: theme.headlineMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Subtitle with feature name
                Text(
                  featureName != null
                      ? 'La fonctionnalité "$featureName" sera disponible dans une prochaine version.'
                      : 'Cette fonctionnalité sera disponible dans une prochaine version.',
                  style: theme.bodyLarge.override(
                    fontFamily: 'General Sans',
                    color: theme.secondaryText,
                    letterSpacing: 0,
                    lineHeight: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Restez connecté ! 🚀',
                  style: theme.bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Back button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Retour',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}

/// Helper to show coming soon for a specific feature.
void showComingSoon(BuildContext context, String featureName) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ComingSoonScreen(featureName: featureName),
    ),
  );
}

