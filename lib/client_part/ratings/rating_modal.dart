/// Rating modal widget for submitting reviews.
///
/// **PR-F26-REFACTOR:** Extracted from HomeWidget.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/missions/mission_models.dart';
import '/services/ratings/ratings_service.dart';

/// Result of a rating submission.
class RatingSubmissionResult {
  const RatingSubmissionResult({
    required this.isSuccess,
    required this.isAlreadyRated,
    this.errorMessage,
  });

  final bool isSuccess;
  final bool isAlreadyRated;
  final String? errorMessage;
}

/// Shows the rating modal bottom sheet.
///
/// Returns a [RatingSubmissionResult] indicating success or failure.
Future<RatingSubmissionResult?> showRatingModal({
  required BuildContext context,
  required Mission mission,
  required String targetUserId,
}) async {
  return showModalBottomSheet<RatingSubmissionResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) {
      return _RatingModalContent(
        mission: mission,
        targetUserId: targetUserId,
      );
    },
  );
}

class _RatingModalContent extends StatefulWidget {
  const _RatingModalContent({
    required this.mission,
    required this.targetUserId,
  });

  final Mission mission;
  final String targetUserId;

  @override
  State<_RatingModalContent> createState() => _RatingModalContentState();
}

class _RatingModalContentState extends State<_RatingModalContent> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedRating == 0 || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    debugPrint('[RatingModal] Submitting rating for mission: ${widget.mission.id}');

    try {
      final result = await RatingsService.createReview(
        toUserId: widget.targetUserId,
        rating: _selectedRating,
        missionId: widget.mission.id,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );

      if (!mounted) return;

      if (result.isSuccess) {
        debugPrint('[RatingModal] Rating submitted successfully');
        Navigator.of(context).pop(
          const RatingSubmissionResult(
            isSuccess: true,
            isAlreadyRated: false,
          ),
        );
      } else {
        final errorMessage = result.errorMessage ?? 'Impossible d\'envoyer l\'évaluation';
        debugPrint('[RatingModal] Rating error: $errorMessage');

        final isAlreadyRated = errorMessage.contains('déjà');

        if (isAlreadyRated) {
          // Already rated - close modal and report
          Navigator.of(context).pop(
            RatingSubmissionResult(
              isSuccess: false,
              isAlreadyRated: true,
              errorMessage: errorMessage,
            ),
          );
        } else {
          // Other error - show snackbar and stay in modal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() => _isSubmitting = false);
        }
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('[RatingModal] Rating unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'envoyer l\'évaluation. Réessayez.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Title
          Text(
            'Évaluer la mission',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: 8),
          Text(
            widget.mission.title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: 24),
          // Star rating
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starValue),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      starValue <= _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 24),
          // Comment field
          TextFormField(
            controller: _commentController,
            maxLength: 300,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Commentaire (optionnel)',
              hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: 24),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_selectedRating == 0 || _isSubmitting) ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor:
                    FlutterFlowTheme.of(context).primary.withOpacity(0.5),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Envoyer',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'General Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                    ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

