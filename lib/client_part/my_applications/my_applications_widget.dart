import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_service.dart';
import '/services/offers/offer_models.dart';
import '/services/offers/offers_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Page displaying user's mission applications.
///
/// Shows all offers/applications with their status.
///
/// **PR-F16:** Initial implementation.
class MyApplicationsWidget extends StatefulWidget {
  const MyApplicationsWidget({super.key});

  static String routeName = 'MyApplications';
  static String routePath = '/myApplications';

  @override
  State<MyApplicationsWidget> createState() => _MyApplicationsWidgetState();
}

class _MyApplicationsWidgetState extends State<MyApplicationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Offer> _applications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final applications = await OffersService.getMyApplications();

      if (!mounted) return;

      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = WkCopy.errorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.pagePadding,
        vertical: WkSpacing.lg,
      ),
      child: Row(
        children: [
          wrapWithModel(
            model: createModel(context, () => BackIconBtnModel()),
            updateCallback: () => setState(() {}),
            child: BackIconBtnWidget(),
          ),
          SizedBox(width: WkSpacing.md),
          Text(
            WkCopy.myApplications,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          Spacer(),
          // Refresh button
          IconButton(
            onPressed: _loadApplications,
            icon: Icon(
              Icons.refresh,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState(context);
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    if (_applications.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildApplicationsList(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(height: WkSpacing.lg),
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

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: WkIconSize.xxxl,
              color: WkStatusColors.cancelled,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              _errorMessage!,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: WkSpacing.xl),
            ElevatedButton.icon(
              onPressed: _loadApplications,
              icon: Icon(Icons.refresh),
              label: Text(WkCopy.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.xl,
                  vertical: WkSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WkRadius.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: WkSpacing.xl),
            Text(
              WkCopy.emptyApplications,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              WkCopy.emptyApplicationsHint,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: WkSpacing.xxl),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Icons.explore),
              label: Text('Explorer les missions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: WkSpacing.xl,
                  vertical: WkSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WkRadius.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadApplications,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.separated(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        itemCount: _applications.length,
        separatorBuilder: (_, __) => SizedBox(height: WkSpacing.md),
        itemBuilder: (context, index) {
          return _buildApplicationCard(context, _applications[index]);
        },
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Offer offer) {
    final statusColor = _getStatusColor(offer.status);
    final statusText = _getStatusText(offer.status);
    final dateFormatted = DateFormat('dd MMM yyyy', 'fr_FR').format(offer.createdAt);

    return InkWell(
      onTap: () => _navigateToMission(offer),
      borderRadius: BorderRadius.circular(WkRadius.card),
      child: Container(
        padding: EdgeInsets.all(WkSpacing.cardPadding),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.card),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge + date row
            Row(
              children: [
                _buildStatusBadge(context, statusText, statusColor),
                Spacer(),
                Text(
                  '${WkCopy.appliedOn} $dateFormatted',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            SizedBox(height: WkSpacing.md),

            // Mission title (if available)
            if (offer.mission != null) ...[
              Text(
                offer.mission!.title,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: WkSpacing.sm),

              // Mission details row
              Row(
                children: [
                  if (offer.mission!.city.isNotEmpty) ...[
                    Icon(
                      Icons.location_on_outlined,
                      size: WkIconSize.sm,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(width: WkSpacing.xs),
                    Text(
                      offer.mission!.city,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(width: WkSpacing.lg),
                  ],
                  Icon(
                    Icons.attach_money,
                    size: WkIconSize.sm,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  Text(
                    '${offer.mission!.price.toStringAsFixed(0)} \$',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ] else ...[
              // Fallback if mission not embedded
              Text(
                'Mission #${offer.missionId.substring(0, 8)}...',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
              ),
            ],

            SizedBox(height: WkSpacing.md),

            // View mission button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _navigateToMission(offer),
                icon: Icon(
                  Icons.arrow_forward,
                  size: WkIconSize.sm,
                ),
                label: Text(WkCopy.viewMission),
                style: TextButton.styleFrom(
                  foregroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: WkSpacing.md,
                    vertical: WkSpacing.sm,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WkSpacing.md,
        vertical: WkSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(WkRadius.badge),
      ),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'General Sans',
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Color _getStatusColor(OfferStatus status) {
    switch (status) {
      case OfferStatus.pending:
        return WkStatusColors.inProgress;
      case OfferStatus.accepted:
        return WkStatusColors.open;
      case OfferStatus.rejected:
        return WkStatusColors.cancelled;
      case OfferStatus.cancelled:
        return WkStatusColors.completed;
      case OfferStatus.expired:
        return WkStatusColors.completed;
      case OfferStatus.unknown:
        return WkStatusColors.unknown;
    }
  }

  String _getStatusText(OfferStatus status) {
    switch (status) {
      case OfferStatus.pending:
        return WkCopy.applicationPending;
      case OfferStatus.accepted:
        return WkCopy.applicationAccepted;
      case OfferStatus.rejected:
        return WkCopy.applicationRejected;
      case OfferStatus.cancelled:
        return WkCopy.applicationCancelled;
      case OfferStatus.expired:
        return WkCopy.applicationExpired;
      case OfferStatus.unknown:
        return 'Inconnu';
    }
  }

  Future<void> _navigateToMission(Offer offer) async {
    // If mission is embedded, use it directly
    if (offer.mission != null) {
      context.pushNamed(
        MissionDetailWidget.routeName,
        queryParameters: {
          'missionId': offer.missionId,
        },
        extra: {'mission': offer.mission},
      );
    } else {
      // Otherwise just pass the ID
      context.pushNamed(
        MissionDetailWidget.routeName,
        queryParameters: {
          'missionId': offer.missionId,
        },
      );
    }
  }
}

