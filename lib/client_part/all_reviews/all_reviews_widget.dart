import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/client_part/components_client/review_item/review_item_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/config/ui_tokens.dart';
import '/services/ratings/ratings_models.dart';
import '/services/ratings/ratings_service.dart';
import 'all_reviews_model.dart';
export 'all_reviews_model.dart';

/// All reviews page.
///
/// **PR-F21:** Wired to RatingsService for real data.
class AllReviewsWidget extends StatefulWidget {
  const AllReviewsWidget({
    super.key,
    this.userId,
  });

  /// The userId to fetch reviews for.
  /// If null, fetches current user's reviews.
  final String? userId;

  static String routeName = 'AllReviews';
  static String routePath = '/allReviews';

  @override
  State<AllReviewsWidget> createState() => _AllReviewsWidgetState();
}

class _AllReviewsWidgetState extends State<AllReviewsWidget> {
  late AllReviewsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // PR-F21: Real data state
  bool _isLoading = true;
  String? _errorMessage;
  RatingSummary _summary = const RatingSummary.empty();
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllReviewsModel());
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load summary and reviews in parallel
      final userId = widget.userId;
      
      late RatingsResult<RatingSummary> summaryResult;
      late RatingsResult<List<Review>> reviewsResult;

      if (userId != null) {
        summaryResult = await RatingsService.fetchSummary(userId);
        reviewsResult = await RatingsService.fetchReviews(userId);
      } else {
        summaryResult = await RatingsService.fetchMySummary();
        reviewsResult = await RatingsService.fetchMyReviews();
      }

      if (!mounted) return;

      if (summaryResult.isSuccess && reviewsResult.isSuccess) {
        setState(() {
          _summary = summaryResult.data!;
          _reviews = reviewsResult.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = summaryResult.errorMessage ?? reviewsResult.errorMessage ?? WkCopy.errorReviews;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = WkCopy.errorReviews;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.backIconBtnModel,
                      updateCallback: () => safeSetState(() {}),
                      child: BackIconBtnWidget(),
                    ),
                    Flexible(
                      child: Text(
                        WkCopy.allReviews,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(width: 15.0)),
                ),
              ),
              wrapWithModel(
                model: _model.searchBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: SearchBtnWidget(),
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(height: WkSpacing.md),
            Text(
              WkCopy.loading,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(WkSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: FlutterFlowTheme.of(context).error,
              ),
              SizedBox(height: WkSpacing.md),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: WkSpacing.lg),
              FFButtonWidget(
                onPressed: _loadData,
                text: WkCopy.retry,
                options: FFButtonOptions(
                  height: 40,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'General Sans',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  borderRadius: BorderRadius.circular(WkRadius.button),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (_reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(WkSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
              ),
              SizedBox(height: WkSpacing.md),
              Text(
                WkCopy.emptyReviews,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      fontSize: 16,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: WkSpacing.sm),
              Text(
                WkCopy.emptyReviewsHint,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Success state with data
    return RefreshIndicator(
      onRefresh: _loadData,
      color: FlutterFlowTheme.of(context).primary,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Summary section
              _buildSummarySection(context),
              Divider(
                height: 1.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              // Reviews list
              ..._reviews.map((review) => _buildReviewItem(context, review)),
            ]
                .divide(SizedBox(height: 20.0))
                .addToStart(SizedBox(height: 20.0))
                .addToEnd(SizedBox(height: 20.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                _summary.formattedAverage,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      fontSize: 40.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final filled = index < _summary.average.round();
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: filled
                        ? FlutterFlowTheme.of(context).tertiary
                        : FlutterFlowTheme.of(context).accent3,
                    size: 24.0,
                  );
                }),
              ),
              SizedBox(height: WkSpacing.sm),
              Text(
                _summary.formattedCount,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
        if (_summary.distribution != null) ...[
          SizedBox(
            height: 120.0,
            child: VerticalDivider(
              width: 1.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 5; i >= 1; i--)
                  _buildRatingBar(context, i, _summary.getPercentage(i)),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        ],
      ].divide(SizedBox(width: 15.0)),
    );
  }

  Widget _buildRatingBar(BuildContext context, int rating, double percentage) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '$rating',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: FlutterFlowTheme.of(context).alternate,
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).tertiary,
              ),
              minHeight: 6.0,
            ),
          ),
        ),
      ].divide(SizedBox(width: 10.0)),
    );
  }

  Widget _buildReviewItem(BuildContext context, Review review) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        child: review.authorAvatar != null
                            ? Container(
                                width: 45.0,
                                height: 45.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  review.authorAvatar!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildInitialsAvatar(context, review),
                                ),
                              )
                            : _buildInitialsAvatar(context, review),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.authorName ?? WkCopy.user,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              review.formattedDate,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ].divide(SizedBox(height: 3.0)),
                        ),
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                ),
                // Rating
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: FlutterFlowTheme.of(context).tertiary,
                      size: 20.0,
                    ),
                    Text(
                      review.formattedRating,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ].divide(SizedBox(width: 3.0)),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
            // Tags
            if (review.tags != null && review.tags!.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: review.tags!.map((tag) => Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 6.0, 10.0, 6.0),
                    child: Text(
                      tag,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                )).toList(),
              ),
            // Comment
            if (review.comment != null && review.comment!.isNotEmpty)
              Text(
                review.comment!,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      letterSpacing: 0.0,
                    ),
              ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(BuildContext context, Review review) {
    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          review.authorInitials,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}
