/// Pay button widget for completed missions.
///
/// **PR-RC1:** Stripe payment integration.
library;

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/missions/mission_models.dart';
import '/services/auth/auth_service.dart';

/// Button to initiate payment for completed missions.
///
/// Only visible when:
/// - Mission status is completed
/// - Current user is the employer (createdByUserId)
/// - No payment in progress
class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.mission,
    required this.isPaying,
    required this.onPressed,
  });

  /// The mission to pay for.
  final Mission mission;

  /// Whether a payment is in progress.
  final bool isPaying;

  /// Callback when button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Visibility conditions
    if (mission.status != MissionStatus.completed) return const SizedBox.shrink();

    // Only employer can pay (the one who created the mission)
    final currentUserId = AuthService.currentUser?.id;
    final isEmployer = mission.createdByUserId == currentUserId;
    
    if (!isEmployer) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isPaying ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              disabledBackgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isPaying
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payment, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Payer ${mission.formattedPrice}',
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


