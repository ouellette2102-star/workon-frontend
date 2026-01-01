/// Rating button widget for completed missions.
///
/// **PR-F26-REFACTOR:** Extracted from HomeWidget.
library;

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/missions/mission_models.dart';
import '/services/auth/auth_service.dart';

/// Button to trigger the rating modal for completed missions.
///
/// Displays "Noter l'employeur" or "Noter le travailleur" based on role.
/// Only visible when:
/// - Tab is "Mes missions"
/// - Mission status is completed
/// - Mission not already rated
/// - No rating in progress
class RatingButton extends StatelessWidget {
  const RatingButton({
    super.key,
    required this.mission,
    required this.isMyMissionsTab,
    required this.isRated,
    required this.isRating,
    required this.onPressed,
  });

  /// The mission to rate.
  final Mission mission;

  /// Whether we are on the "Mes missions" tab.
  final bool isMyMissionsTab;

  /// Whether this mission has already been rated.
  final bool isRated;

  /// Whether a rating submission is in progress.
  final bool isRating;

  /// Callback when button is pressed. Receives targetUserId.
  final void Function(String targetUserId) onPressed;

  @override
  Widget build(BuildContext context) {
    // Visibility conditions
    if (!isMyMissionsTab) return const SizedBox.shrink();
    if (mission.status != MissionStatus.completed) return const SizedBox.shrink();
    if (isRated) return const SizedBox.shrink();
    if (isRating) return const SizedBox.shrink();

    // Determine target user for rating
    final currentUserId = AuthService.currentUser?.id;
    final isAssignedWorker = mission.assignedToUserId == currentUserId;
    final targetUserId = isAssignedWorker ? mission.createdByUserId : mission.assignedToUserId;

    // No target = can't rate
    if (targetUserId == null) return const SizedBox.shrink();

    // Button text based on role
    final buttonText = isAssignedWorker ? 'Noter l\'employeur' : 'Noter le travailleur';

    return Column(
      children: [
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onPressed(targetUserId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 20),
                SizedBox(width: 8),
                Text(
                  buttonText,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

