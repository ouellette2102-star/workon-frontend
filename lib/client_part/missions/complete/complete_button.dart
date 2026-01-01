/// Complete mission button widget.
///
/// **PR-F25-REFACTOR:** Extracted from HomeWidget.
library;

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/missions/mission_models.dart';

/// Button to complete an in_progress mission (worker only).
///
/// Only visible when:
/// - User is a worker
/// - Tab is "Mes missions"
/// - Mission status is in_progress
/// - No completion in progress for this mission
class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.mission,
    required this.isWorker,
    required this.isMyMissionsTab,
    required this.isFinishing,
    required this.onPressed,
  });

  /// The mission to complete.
  final Mission mission;

  /// Whether the current user is a worker.
  final bool isWorker;

  /// Whether we are on the "Mes missions" tab.
  final bool isMyMissionsTab;

  /// Whether a completion is in progress for this mission.
  final bool isFinishing;

  /// Callback when button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Visibility conditions (strict)
    if (!isWorker) return const SizedBox.shrink();
    if (!isMyMissionsTab) return const SizedBox.shrink();
    if (mission.status != MissionStatus.inProgress) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isFinishing ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: Colors.teal.withOpacity(0.5),
            ),
            child: isFinishing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Terminer',
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

