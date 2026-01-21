import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/ratings/ratings_service.dart';
import '/index.dart';
import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';

/// Simple leave review screen.
///
/// **PR-F21:** MVP minimal review submission.
class LeaveReviewSimpleWidget extends StatefulWidget {
  const LeaveReviewSimpleWidget({
    super.key,
    required this.toUserId,
    this.toUserName,
    this.toUserAvatar,
    this.missionId,
    this.missionTitle,
  });

  /// The user being reviewed.
  final String toUserId;

  /// Display name of the user (optional).
  final String? toUserName;

  /// Avatar URL (optional).
  final String? toUserAvatar;

  /// Mission ID for context (optional).
  /// NOTE (Post-MVP): Enforce missionId when backend supports it.
  final String? missionId;

  /// Mission title for display (optional).
  final String? missionTitle;

  static String routeName = 'LeaveReviewSimple';
  static String routePath = '/leaveReviewSimple';

  @override
  State<LeaveReviewSimpleWidget> createState() =>
      _LeaveReviewSimpleWidgetState();
}

class _LeaveReviewSimpleWidgetState extends State<LeaveReviewSimpleWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();

  double _rating = 0;
  List<String> _selectedTags = [];
  bool _isSubmitting = false;

  // Tag options (FR)
  final List<String> _tagOptions = [
    'Ponctuel',
    'Professionnel',
    'Sympathique',
    'Qualité',
    'Rapide',
    'Bien équipé',
    'Bonne communication',
    'Recommandé',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    // Validate rating
    if (_rating < 1) {
      _showSnackbar(WkCopy.ratingRequired, isError: true);
      return;
    }

    // Validate comment length
    if (_commentController.text.length > 500) {
      _showSnackbar(WkCopy.commentMaxLength, isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await RatingsService.createReview(
      toUserId: widget.toUserId,
      rating: _rating.round(),
      missionId: widget.missionId,
      comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      tags: _selectedTags.isNotEmpty ? _selectedTags : null,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.isSuccess) {
      _showSnackbar(WkCopy.reviewSuccess);
      // Navigate back after success
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.safePop();
      }
    } else {
      _showSnackbar(result.errorMessage ?? WkCopy.reviewError, isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              BackIconBtnWidget(),
              SizedBox(width: WkSpacing.lg),
              Flexible(
                child: Text(
                  WkCopy.leaveReview,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(WkSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info header
                      _buildUserHeader(context),
                      SizedBox(height: WkSpacing.xxl),

                      // Mission context (if provided)
                      if (widget.missionTitle != null) ...[
                        _buildMissionContext(context),
                        SizedBox(height: WkSpacing.xxl),
                      ],

                      // Rating section
                      _buildRatingSection(context),
                      SizedBox(height: WkSpacing.xxl),

                      // Tags section
                      _buildTagsSection(context),
                      SizedBox(height: WkSpacing.xxl),

                      // Comment section
                      _buildCommentSection(context),
                    ],
                  ),
                ),
              ),

              // Submit button
              Padding(
                padding: EdgeInsets.all(WkSpacing.xl),
                child: FFButtonWidget(
                  onPressed: _isSubmitting ? null : _submitReview,
                  text: _isSubmitting ? WkCopy.saving : WkCopy.submitReview,
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(30.0),
                    disabledColor: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              shape: BoxShape.circle,
            ),
            child: widget.toUserAvatar != null
                ? ClipOval(
                    child: Image.network(
                      widget.toUserAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildInitialsAvatar(context),
                    ),
                  )
                : _buildInitialsAvatar(context),
          ),
          SizedBox(height: WkSpacing.md),
          // Name
          Text(
            widget.toUserName ?? WkCopy.user,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(BuildContext context) {
    final name = widget.toUserName ?? 'U';
    final parts = name.trim().split(' ');
    String initials = '?';
    if (parts.isNotEmpty) {
      initials = parts.length == 1
          ? parts[0][0].toUpperCase()
          : '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }

    return Center(
      child: Text(
        initials,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'General Sans',
              fontSize: 32,
              color: FlutterFlowTheme.of(context).primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Widget _buildMissionContext(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WkSpacing.md),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.card),
      ),
      child: Row(
        children: [
          Icon(
            Icons.work_outline,
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Text(
              widget.missionTitle!,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          WkCopy.experienceWith,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: WkSpacing.md),
        Center(
          child: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 8.0),
            itemSize: 48.0,
            unratedColor: FlutterFlowTheme.of(context).accent3,
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: FlutterFlowTheme.of(context).tertiary,
            ),
            onRatingUpdate: (rating) {
              setState(() => _rating = rating);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          WkCopy.whatStoodOut,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: WkSpacing.md),
        Wrap(
          spacing: WkSpacing.sm,
          runSpacing: WkSpacing.sm,
          children: _tagOptions.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: AnimatedContainer(
                duration: WkDuration.fast,
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.lg,
                  vertical: WkSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  tag,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: isSelected
                            ? Colors.white
                            : FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          WkCopy.yourComment,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: WkSpacing.md),
        TextFormField(
          controller: _commentController,
          focusNode: _commentFocusNode,
          maxLines: 5,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: WkCopy.commentHint,
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              borderRadius: BorderRadius.circular(WkRadius.card),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
              ),
              borderRadius: BorderRadius.circular(WkRadius.card),
            ),
            contentPadding: EdgeInsets.all(WkSpacing.lg),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}

