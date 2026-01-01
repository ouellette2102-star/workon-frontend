/// Complete mission handler.
///
/// **PR-F25-REFACTOR:** Extracted from HomeWidget.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/services/missions/missions_service.dart';
import '/services/missions/missions_api.dart';
import '/services/auth/auth_errors.dart';

/// Result of a complete mission operation.
class CompleteMissionResult {
  const CompleteMissionResult({
    required this.isSuccess,
    this.errorMessage,
  });

  final bool isSuccess;
  final String? errorMessage;
}

/// Handles the complete mission action.
///
/// Calls `MissionsService.complete()` and returns a result.
/// The caller is responsible for:
/// - Managing loading state (finishingMissionIds)
/// - Showing snackbars
/// - Refreshing the missions list
Future<CompleteMissionResult> handleCompleteMission(String missionId) async {
  debugPrint('[CompleteHandler] Completing mission: $missionId');

  try {
    await MissionsService.complete(missionId);
    debugPrint('[CompleteHandler] Mission completed successfully');
    return const CompleteMissionResult(isSuccess: true);
  } on UnauthorizedException {
    debugPrint('[CompleteHandler] Unauthorized');
    return const CompleteMissionResult(
      isSuccess: false,
      errorMessage: 'Session expirée. Veuillez vous reconnecter.',
    );
  } on MissionsApiException catch (e) {
    debugPrint('[CompleteHandler] API error: ${e.message}');
    return CompleteMissionResult(
      isSuccess: false,
      errorMessage: e.message,
    );
  } catch (e) {
    debugPrint('[CompleteHandler] Unexpected error: $e');
    return const CompleteMissionResult(
      isSuccess: false,
      errorMessage: 'Impossible de terminer la mission. Réessaie.',
    );
  }
}

/// Shows the appropriate snackbar for a complete mission result.
void showCompleteMissionSnackbar(BuildContext context, CompleteMissionResult result) {
  if (result.isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mission terminée !'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.errorMessage ?? 'Impossible de terminer la mission. Réessaie.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

