import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/analytics/analytics_service.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import '/services/missions/missions_service.dart';
import '/services/offers/offers_service.dart';
import '/services/auth/auth_service.dart';
import '/services/saved/saved_missions_store.dart';
// PR-CHAT: Import ChatWidget for mission chat access
import '/client_part/chat/chat_widget.dart';
// PR-BOOKING: Import StripeService for payment flow
import '/services/payments/stripe_service.dart';
// FL-SPRINT3: Mission Timeline
import '/components/mission_timeline_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'mission_detail_model.dart';
export 'mission_detail_model.dart';

/// Mission detail page with actions.
///
/// Displays mission information and allows user to apply.
///
/// **PR-F05b:** Initial implementation.
/// **PR-F06:** Real data fetch + retry on error + improved logging.
/// **PR-F09:** Added Actions section (UI only, no API calls).
/// **PR-F11:** Made "Sauvegarder" functional with local persistence.
/// **PR-F12:** Made "Partager" functional with OS share sheet.
/// **PR-F15:** Made "Postuler" functional with real API integration.
class MissionDetailWidget extends StatefulWidget {
  const MissionDetailWidget({
    super.key,
    required this.missionId,
    this.mission,
  });

  /// Route name for navigation.
  static String routeName = 'MissionDetail';

  /// Route path for GoRouter.
  static String routePath = '/missionDetail';

  /// Mission ID to display.
  final String missionId;

  /// Optional pre-loaded mission data.
  /// If null, will fetch from service.
  final Mission? mission;

  @override
  State<MissionDetailWidget> createState() => _MissionDetailWidgetState();
}

class _MissionDetailWidgetState extends State<MissionDetailWidget> {
  late MissionDetailModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Mission? _mission;
  bool _isLoading = true;
  String? _errorMessage;

  // PR-F11: Saved state
  bool _isSaved = false;

  // PR-F15: Apply state
  bool _hasApplied = false;
  bool _isApplying = false;

  // PR-04: Employer lifecycle actions
  bool _isStarting = false;
  bool _isCompleting = false;

  // PR-BOOKING: Payment state
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MissionDetailModel());

    // PR-F11: Check saved state
    _isSaved = SavedMissionsStore.isSaved(widget.missionId);

    // PR-F15: Check applied state
    _hasApplied = OffersService.hasApplied(widget.missionId);

    // PR-F06: Use provided mission or load from service
    if (widget.mission != null) {
      debugPrint('[MissionDetail] Using provided mission: ${widget.mission!.id}');
      _mission = widget.mission;
      _isLoading = false;
      // PR-23: Track mission viewed
      AnalyticsService.trackMissionViewed(
        missionId: widget.mission!.id,
        category: widget.mission!.category,
        price: widget.mission!.price,
      );
    } else if (widget.missionId.isNotEmpty) {
      debugPrint('[MissionDetail] Fetching mission by ID: ${widget.missionId}');
      _loadMission();
    } else {
      debugPrint('[MissionDetail] No mission data or ID provided');
      _isLoading = false;
      _errorMessage = 'ID de mission manquant';
    }
  }

  /// PR-F06: Load mission from backend with improved error handling.
  Future<void> _loadMission() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint('[MissionDetail] Loading mission ${widget.missionId}...');

    try {
      final mission = await MissionsService.getById(widget.missionId);
      
      if (!mounted) return;
      
      if (mission != null) {
        debugPrint('[MissionDetail] Mission loaded: ${mission.title}');
        // PR-23: Track mission viewed
        AnalyticsService.trackMissionViewed(
          missionId: mission.id,
          category: mission.category,
          price: mission.price,
        );
        setState(() {
          _mission = mission;
          _isLoading = false;
        });
      } else {
        debugPrint('[MissionDetail] Mission not found');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Mission introuvable';
        });
      }
    } on MissionsApiException catch (e) {
      debugPrint('[MissionDetail] API error: ${e.message}');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      debugPrint('[MissionDetail] Unexpected error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur de chargement. Vérifiez votre connexion.';
        });
      }
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
            children: [
              wrapWithModel(
                model: createModel(context, () => BackIconBtnModel()),
                updateCallback: () => safeSetState(() {}),
                child: BackIconBtnWidget(),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  WkCopy.missionDetail,
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

    // Error state - PR-F06: Added Retry button
    if (_errorMessage != null || _mission == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(WkSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: FlutterFlowTheme.of(context).error,
                size: WkIconSize.xxxl,
              ),
              SizedBox(height: WkSpacing.lg),
              Text(
                _errorMessage ?? WkCopy.errorMissionNotFound,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: WkSpacing.xl),
              // PR-F06: Retry button (only if we have an ID to retry with)
              if (widget.missionId.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: WkSpacing.sm),
                  child: FFButtonWidget(
                    onPressed: _loadMission,
                    text: WkCopy.retry,
                    options: FFButtonOptions(
                      padding: EdgeInsets.symmetric(
                          horizontal: WkSpacing.xxl, vertical: WkSpacing.md),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                          ),
                      borderRadius: BorderRadius.circular(WkRadius.lg),
                    ),
                  ),
                ),
              FFButtonWidget(
                onPressed: () => context.pop(),
                text: WkCopy.back,
                options: FFButtonOptions(
                  padding: EdgeInsets.symmetric(
                      horizontal: WkSpacing.xxl, vertical: WkSpacing.md),
                  color: FlutterFlowTheme.of(context).alternate,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                      ),
                  borderRadius: BorderRadius.circular(WkRadius.lg),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mission detail
    final mission = _mission!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(context, mission),
            SizedBox(height: WkSpacing.sectionGap),

            // Description section
            _buildSection(
              context,
              title: WkCopy.description,
              child: Text(
                mission.description.isNotEmpty
                    ? mission.description
                    : WkCopy.noDescription,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      letterSpacing: 0.0,
                      lineHeight: 1.5,
                    ),
              ),
            ),
            SizedBox(height: WkSpacing.sectionGap),

            // Location section
            _buildSection(
              context,
              title: WkCopy.location,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.location_city,
                    label: WkCopy.city,
                    value: mission.city,
                  ),
                  if (mission.address != null && mission.address!.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on,
                      label: WkCopy.address,
                      value: mission.address!,
                    ),
                  _buildInfoRow(
                    context,
                    icon: Icons.my_location,
                    label: WkCopy.coordinates,
                    value:
                        '${mission.latitude.toStringAsFixed(4)}, ${mission.longitude.toStringAsFixed(4)}',
                  ),
                  if (mission.distanceKm != null)
                    _buildInfoRow(
                      context,
                      icon: Icons.straighten,
                      label: WkCopy.distance,
                      value: mission.formattedDistance ?? '',
                    ),
                ],
              ),
            ),
            SizedBox(height: WkSpacing.sectionGap),

            // Details section
            _buildSection(
              context,
              title: WkCopy.information,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.category,
                    label: WkCopy.category,
                    value: _formatCategory(mission.category),
                  ),
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time,
                    label: WkCopy.publishedOn,
                    value: _formatDate(mission.createdAt),
                  ),
                ],
              ),
            ),
            SizedBox(height: WkSpacing.sectionGap),

            // PR-F09: Actions section
            _buildActionsSection(context, mission),
            SizedBox(height: WkSpacing.md),

            // PR-F09: Legal disclaimer
            _buildLegalDisclaimer(context),
            SizedBox(height: WkSpacing.sectionGap),

            // FL-SPRINT3: Mission Timeline (events history)
            if (mission.status != MissionStatus.open)
              Container(
                padding: EdgeInsets.all(WkSpacing.md),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(WkRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: WkIconSize.md,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        SizedBox(width: WkSpacing.sm),
                        Text(
                          'Historique',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: WkSpacing.md),
                    MissionTimelineWidget(
                      missionId: mission.id,
                      compact: true,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 100), // Bottom padding for scroll
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Mission mission) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(WkRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: WkSpacing.md, vertical: WkSpacing.xs + 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(WkRadius.xxl),
            ),
            child: Text(
              mission.status.displayName,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          SizedBox(height: WkSpacing.md),

          // Title
          Text(
            mission.title,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'General Sans',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.sm),

          // Location
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white70, size: WkIconSize.md - 2),
              SizedBox(width: WkSpacing.xs + 2),
              Expanded(
                child: Text(
                  mission.city,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: Colors.white70,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: WkSpacing.lg),

          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WkCopy.budget,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: Colors.white70,
                      letterSpacing: 0.0,
                    ),
              ),
              Text(
                mission.formattedPrice,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.cardPadding),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: WkSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(WkRadius.button),
            ),
            child: Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: WkIconSize.md - 2,
            ),
          ),
          SizedBox(width: WkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    switch (category.toLowerCase()) {
      case 'snow_removal':
      case 'deneigement':
        return 'Déneigement';
      case 'cleaning':
      case 'menage':
        return 'Ménage';
      case 'plumbing':
      case 'plomberie':
        return 'Plomberie';
      case 'painting':
      case 'peinture':
        return 'Peinture';
      case 'gardening':
      case 'jardinage':
        return 'Jardinage';
      case 'moving':
      case 'demenagement':
        return 'Déménagement';
      case 'handyman':
      case 'bricolage':
        return 'Bricolage';
      default:
        return category.replaceAll('_', ' ');
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-F09: Actions Section
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check if mission is available for application.
  bool _isMissionAvailable(Mission mission) {
    return mission.status == MissionStatus.open;
  }

  /// Show a snackbar with the given message.
  ///
  /// [isSuccess] shows green background.
  /// [isError] shows red background.
  void _showSnackbar(String message, {bool isSuccess = false, bool isError = false}) {
    Color bgColor;
    if (isSuccess) {
      bgColor = WkStatusColors.open;
    } else if (isError) {
      bgColor = WkStatusColors.cancelled;
    } else {
      bgColor = FlutterFlowTheme.of(context).primaryText;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                color: Colors.white,
                letterSpacing: 0.0,
              ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WkRadius.button),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// PR-F09: Builds the actions section with CTA buttons.
  Widget _buildActionsSection(BuildContext context, Mission mission) {
    final isAvailable = _isMissionAvailable(mission);
    
    // PR-04: Check if user is the mission creator (employer view)
    final currentUserId = AuthService.currentUserId;
    final isOwner = currentUserId != null && mission.createdByUserId == currentUserId;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WkSpacing.cardPadding),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(WkRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            WkCopy.actions,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: WkSpacing.lg),

          // PR-04: Show employer actions if user is owner
          if (isOwner) ...[
            _buildStatusTimeline(context, mission),
            SizedBox(height: WkSpacing.lg),
            _buildEmployerActions(context, mission),
          ] else ...[
            // Primary CTA: Postuler (PR-F15: real API integration)
            _buildApplyButton(context, mission, isAvailable),
          ],
          SizedBox(height: WkSpacing.md),

          // PR-CHAT: Chat button for assigned/in-progress missions
          if (mission.status != MissionStatus.open &&
              mission.status != MissionStatus.cancelled) ...[
            _buildChatButton(context, mission),
            SizedBox(height: WkSpacing.md),
          ],

          // Secondary actions row: Share + Save
          Row(
            children: [
              // PR-F12: Functional share button
              Expanded(
                child: _buildSecondaryAction(
                  context,
                  icon: Icons.share_outlined,
                  label: WkCopy.share,
                  onTap: () => _shareMission(mission),
                ),
              ),
              SizedBox(width: WkSpacing.md),
              // PR-F11: Functional save button
              Expanded(
                child: _buildSaveAction(context, mission),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-F15: Apply Button
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-F15: Builds the apply button with real API integration.
  Widget _buildApplyButton(
    BuildContext context,
    Mission mission,
    bool isAvailable,
  ) {
    // Determine button state
    final bool canApply = isAvailable && !_hasApplied && !_isApplying;

    // Determine button text
    String buttonText;
    if (_isApplying) {
      buttonText = WkCopy.applying;
    } else if (_hasApplied) {
      buttonText = WkCopy.applied;
    } else if (isAvailable) {
      buttonText = WkCopy.apply;
    } else {
      buttonText = WkCopy.applyDisabled;
    }

    // Determine button color
    Color buttonColor;
    Color textColor;
    if (_hasApplied) {
      // Already applied - show success state
      buttonColor = WkStatusColors.open.withOpacity(0.2);
      textColor = WkStatusColors.open;
    } else if (canApply) {
      buttonColor = FlutterFlowTheme.of(context).primary;
      textColor = Colors.white;
    } else {
      buttonColor = FlutterFlowTheme.of(context).alternate;
      textColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return SizedBox(
      width: double.infinity,
      child: FFButtonWidget(
        onPressed: canApply ? () => _handleApply(mission) : null,
        text: buttonText,
        options: FFButtonOptions(
          padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
          color: buttonColor,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'General Sans',
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
              ),
          borderRadius: BorderRadius.circular(WkRadius.lg),
          disabledColor: _hasApplied
              ? WkStatusColors.open.withOpacity(0.2)
              : FlutterFlowTheme.of(context).alternate,
          disabledTextColor: _hasApplied
              ? WkStatusColors.open
              : FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }

  /// PR-F15: Handles apply to mission action.
  Future<void> _handleApply(Mission mission) async {
    if (_isApplying || _hasApplied) return;

    debugPrint('[MissionDetail] Applying to mission: ${mission.id}');

    setState(() {
      _isApplying = true;
    });

    final result = await OffersService.applyToMission(mission.id);

    if (!mounted) return;

    setState(() {
      _isApplying = false;
    });

    switch (result) {
      case ApplyResult.success:
        // PR-23: Track offer submitted
        AnalyticsService.trackOfferSubmitted(
          missionId: mission.id,
          offerAmount: mission.price,
        );
        setState(() {
          _hasApplied = true;
        });
        _showSnackbar(WkCopy.applySuccess, isSuccess: true);
        break;

      case ApplyResult.alreadyApplied:
        setState(() {
          _hasApplied = true;
        });
        _showSnackbar(WkCopy.applyAlreadyApplied);
        break;

      case ApplyResult.networkError:
        _showSnackbar(WkCopy.applyNetworkError, isError: true);
        break;

      case ApplyResult.unauthorized:
        _showSnackbar(WkCopy.applyError, isError: true);
        break;

      case ApplyResult.error:
        _showSnackbar(WkCopy.applyError, isError: true);
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-04: Employer Lifecycle Actions
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-04: Builds the status timeline showing mission lifecycle.
  Widget _buildStatusTimeline(BuildContext context, Mission mission) {
    final steps = [
      _TimelineStep(
        label: 'Créée',
        icon: Icons.add_circle_outline,
        isCompleted: true,
        isActive: mission.status == MissionStatus.open,
      ),
      _TimelineStep(
        label: 'Assignée',
        icon: Icons.person_outline,
        isCompleted: mission.status != MissionStatus.open,
        isActive: mission.status == MissionStatus.assigned,
      ),
      _TimelineStep(
        label: 'En cours',
        icon: Icons.play_circle_outline,
        isCompleted: mission.status == MissionStatus.inProgress ||
            mission.status == MissionStatus.completed ||
            mission.status == MissionStatus.paid,
        isActive: mission.status == MissionStatus.inProgress,
      ),
      _TimelineStep(
        label: 'Terminée',
        icon: Icons.check_circle_outline,
        isCompleted: mission.status == MissionStatus.completed ||
            mission.status == MissionStatus.paid,
        isActive: mission.status == MissionStatus.completed ||
            mission.status == MissionStatus.paid,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statut de la mission',
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'General Sans',
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.0,
              ),
        ),
        SizedBox(height: WkSpacing.md),
        Row(
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: step.isCompleted
                                ? (step.isActive
                                    ? FlutterFlowTheme.of(context).primary
                                    : WkStatusColors.completed)
                                : FlutterFlowTheme.of(context).alternate,
                          ),
                          child: Icon(
                            step.icon,
                            size: 18,
                            color: step.isCompleted
                                ? Colors.white
                                : FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        SizedBox(height: WkSpacing.xs),
                        Text(
                          step.label,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'General Sans',
                                fontSize: 10,
                                color: step.isActive
                                    ? FlutterFlowTheme.of(context).primary
                                    : (step.isCompleted
                                        ? FlutterFlowTheme.of(context).primaryText
                                        : FlutterFlowTheme.of(context).secondaryText),
                                fontWeight: step.isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                letterSpacing: 0.0,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: EdgeInsets.only(bottom: 20),
                        color: step.isCompleted
                            ? WkStatusColors.completed
                            : FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// PR-04: Builds employer action buttons (Start/Complete).
  Widget _buildEmployerActions(BuildContext context, Mission mission) {
    // Determine which action is available
    final canStart = mission.status == MissionStatus.assigned;
    final canComplete = mission.status == MissionStatus.inProgress;
    final isTerminal = mission.status == MissionStatus.completed ||
        mission.status == MissionStatus.paid ||
        mission.status == MissionStatus.cancelled;

    if (isTerminal) {
      // PR-BOOKING: If completed but not paid, show Pay button
      if (mission.status == MissionStatus.completed) {
        return Column(
          children: [
            // Status message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(WkSpacing.md),
              decoration: BoxDecoration(
                color: WkStatusColors.completed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(WkRadius.sm),
                border: Border.all(
                  color: WkStatusColors.completed.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: WkStatusColors.completed,
                  ),
                  SizedBox(width: WkSpacing.sm),
                  Expanded(
                    child: Text(
                      'Mission terminée. Procédez au paiement.',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: WkStatusColors.completed,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: WkSpacing.md),
            // Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isPaying ? null : () => _handlePayMission(mission),
                icon: _isPaying
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.payment),
                label: Text(_isPaying ? 'Paiement en cours...' : 'Payer ${mission.price.toStringAsFixed(0)} \$'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WkRadius.lg),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      // Mission already paid or cancelled - show final message
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(WkSpacing.md),
        decoration: BoxDecoration(
          color: WkStatusColors.completed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(WkRadius.sm),
          border: Border.all(
            color: WkStatusColors.completed.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: WkStatusColors.completed,
            ),
            SizedBox(width: WkSpacing.sm),
            Expanded(
              child: Text(
                mission.status == MissionStatus.paid
                    ? 'Cette mission a été payée.'
                    : mission.status == MissionStatus.cancelled
                        ? 'Cette mission a été annulée.'
                        : 'Cette mission est terminée.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: WkStatusColors.completed,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    if (mission.status == MissionStatus.open) {
      // Mission still open - waiting for applications
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(WkSpacing.md),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(WkRadius.sm),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_empty,
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(width: WkSpacing.sm),
            Expanded(
              child: Text(
                'En attente de candidatures. Acceptez un travailleur pour démarrer.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    // Show action buttons
    return Column(
      children: [
        // Start button
        if (canStart)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isStarting ? null : () => _handleStartMission(mission),
              icon: _isStarting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.play_arrow),
              label: Text(_isStarting ? 'Démarrage...' : 'Démarrer la mission'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WkRadius.lg),
                ),
              ),
            ),
          ),

        // Complete button
        if (canComplete)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isCompleting ? null : () => _handleCompleteMission(mission),
              icon: _isCompleting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.check),
              label: Text(_isCompleting ? 'Finalisation...' : 'Marquer comme terminée'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WkStatusColors.completed,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WkRadius.lg),
                ),
              ),
            ),
          ),
          ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-CHAT: Chat Button for Mission Communication
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-CHAT: Builds the chat button to communicate about the mission.
  ///
  /// Opens the chat screen with the mission ID as conversation ID.
  /// Only shown for assigned/in-progress/completed missions.
  Widget _buildChatButton(BuildContext context, Mission mission) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openChat(mission),
        icon: Icon(Icons.chat_bubble_outline),
        label: Text('Contacter'),
        style: OutlinedButton.styleFrom(
          foregroundColor: FlutterFlowTheme.of(context).primary,
          side: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WkRadius.lg),
          ),
        ),
      ),
    );
  }

  /// PR-CHAT: Opens chat screen for this mission.
  void _openChat(Mission mission) {
    debugPrint('[MissionDetail] Opening chat for mission: ${mission.id}');
    context.pushNamed(
      ChatWidget.routeName,
      queryParameters: {
        'conversationId': mission.id,
        'participantName': 'Client', // Mission model doesn't have clientName
      },
    );
  }

  /// PR-04: Handles start mission action.
  Future<void> _handleStartMission(Mission mission) async {
    if (_isStarting) return;

    setState(() {
      _isStarting = true;
    });

    try {
      final api = MissionsApi();
      final updatedMission = await api.startMission(mission.id);

      if (!mounted) return;

      setState(() {
        _isStarting = false;
        _mission = updatedMission;
      });

      _showSnackbar('Mission démarrée !', isSuccess: true);
    } catch (e) {
      debugPrint('[MissionDetail] Error starting mission: $e');
      if (!mounted) return;

      setState(() {
        _isStarting = false;
      });

      final message = e is MissionsApiException
          ? e.message
          : 'Erreur lors du démarrage';
      _showSnackbar(message, isError: true);
    }
  }

  /// PR-04: Handles complete mission action.
  Future<void> _handleCompleteMission(Mission mission) async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      final api = MissionsApi();
      final updatedMission = await api.completeMission(mission.id);

      if (!mounted) return;

      // If backend returned empty mission (204), refetch
      if (updatedMission.title.isEmpty) {
        await _loadMission();
      } else {
        setState(() {
          _mission = updatedMission;
        });
      }

      setState(() {
        _isCompleting = false;
      });

      _showSnackbar('Mission terminée !', isSuccess: true);
    } catch (e) {
      debugPrint('[MissionDetail] Error completing mission: $e');
      if (!mounted) return;

      setState(() {
        _isCompleting = false;
      });

      final message = e is MissionsApiException
          ? e.message
          : 'Erreur lors de la finalisation';
      _showSnackbar(message, isError: true);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-BOOKING: Payment Handler
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-BOOKING: Handles the payment flow for completed missions.
  ///
  /// Uses Stripe Payment Sheet to process payment.
  Future<void> _handlePayMission(Mission mission) async {
    if (_isPaying) return;

    debugPrint('[MissionDetail] Starting payment for mission: ${mission.id}');

    setState(() {
      _isPaying = true;
    });

    try {
      final result = await StripeService.payForMission(missionId: mission.id);

      if (!mounted) return;

      switch (result) {
        case PaymentSheetSuccess():
          debugPrint('[MissionDetail] Payment succeeded');
          // Refresh mission to get updated status (paid)
          await _loadMission();
          _showSnackbar('Paiement réussi !', isSuccess: true);
          break;

        case PaymentSheetCancelled():
          debugPrint('[MissionDetail] Payment cancelled by user');
          _showSnackbar('Paiement annulé');
          break;

        case PaymentSheetError(:final message, :final isAuthError):
          debugPrint('[MissionDetail] Payment error: $message (auth: $isAuthError)');
          if (isAuthError) {
            _showSnackbar('Session expirée. Reconnectez-vous.', isError: true);
          } else {
            _showSnackbar(message, isError: true);
          }
          break;
      }
    } catch (e) {
      debugPrint('[MissionDetail] Payment exception: $e');
      if (!mounted) return;
      _showSnackbar('Erreur de paiement. Réessayez.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isPaying = false;
        });
      }
    }
  }

  /// PR-F09: Builds a secondary action button.
  Widget _buildSecondaryAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WkRadius.button),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: WkSpacing.lg,
          vertical: WkSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(WkRadius.button),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: WkIconSize.md,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            SizedBox(width: WkSpacing.sm),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// PR-F09: Builds the legal disclaimer text.
  Widget _buildLegalDisclaimer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WkSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: WkIconSize.sm,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(width: WkSpacing.sm),
          Expanded(
            child: Text(
              WkCopy.legalDisclaimer,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-F11: Save Button
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-F11: Builds the save action button with toggle functionality.
  Widget _buildSaveAction(BuildContext context, Mission mission) {
    return InkWell(
      onTap: () async {
        final isNowSaved = await SavedMissionsStore.toggleSaved(mission.id);
        setState(() {
          _isSaved = isNowSaved;
        });
        _showSnackbar(isNowSaved ? WkCopy.savedSuccess : WkCopy.unsavedSuccess);
      },
      borderRadius: BorderRadius.circular(WkRadius.button),
      child: AnimatedContainer(
        duration: WkDuration.fast,
        padding: EdgeInsets.symmetric(
          horizontal: WkSpacing.lg,
          vertical: WkSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _isSaved
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: _isSaved
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(WkRadius.button),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              size: WkIconSize.md,
              color: _isSaved
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).primaryText,
            ),
            SizedBox(width: WkSpacing.sm),
            Text(
              _isSaved ? WkCopy.saved : WkCopy.save,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w500,
                    color: _isSaved
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PR-F12: Share Mission
  // ─────────────────────────────────────────────────────────────────────────────

  /// PR-F12: Shares the mission using the OS share sheet.
  Future<void> _shareMission(Mission mission) async {
    try {
      // Build share message with graceful degradation
      final title = mission.title.isNotEmpty ? mission.title : 'Mission WorkOn';
      final city = mission.city.isNotEmpty ? mission.city : '';
      final price = mission.formattedPrice;
      final link = 'workon://mission/${mission.id}';

      // Compose message
      final buffer = StringBuffer();
      buffer.write('🔧 $title');
      if (city.isNotEmpty) {
        buffer.write('\n📍 $city');
      }
      buffer.write('\n💰 $price');
      buffer.write('\n\n$link');

      final message = buffer.toString();

      debugPrint('[MissionDetail] Sharing: $message');

      // Show share sheet
      await Share.share(
        message,
        subject: 'Mission WorkOn: $title',
      );

      debugPrint('[MissionDetail] Share completed');
    } catch (e) {
      debugPrint('[MissionDetail] Share error: $e');
      _showSnackbar(WkCopy.shareError);
    }
  }
}

/// PR-04: Helper class for timeline steps.
class _TimelineStep {
  final String label;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  const _TimelineStep({
    required this.label,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
  });
}

