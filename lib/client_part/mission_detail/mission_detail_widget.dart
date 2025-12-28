import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import '/services/missions/missions_service.dart';
import '/services/saved/saved_missions_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'mission_detail_model.dart';
export 'mission_detail_model.dart';

/// Read-only mission detail page.
///
/// Displays mission information without any write actions.
///
/// **PR-F05b:** Initial implementation.
/// **PR-F06:** Real data fetch + retry on error + improved logging.
/// **PR-F09:** Added Actions section (UI only, no API calls).
/// **PR-F11:** Made "Sauvegarder" functional with local persistence.
/// **PR-F12:** Made "Partager" functional with OS share sheet.
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MissionDetailModel());

    // PR-F11: Check saved state
    _isSaved = SavedMissionsStore.isSaved(widget.missionId);

    // PR-F06: Use provided mission or load from service
    if (widget.mission != null) {
      debugPrint('[MissionDetail] Using provided mission: ${widget.mission!.id}');
      _mission = widget.mission;
      _isLoading = false;
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
                      height: 1.5,
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
  void _showSnackbar(String message) {
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
        backgroundColor: FlutterFlowTheme.of(context).primaryText,
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

          // Primary CTA: Postuler
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: isAvailable
                  ? () => _showSnackbar(WkCopy.comingSoon)
                  : null,
              text: isAvailable ? WkCopy.apply : WkCopy.applyDisabled,
              options: FFButtonOptions(
                padding: EdgeInsets.symmetric(vertical: WkSpacing.lg),
                color: isAvailable
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).alternate,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: isAvailable
                          ? Colors.white
                          : FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                borderRadius: BorderRadius.circular(WkRadius.lg),
                disabledColor: FlutterFlowTheme.of(context).alternate,
                disabledTextColor: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ),
          SizedBox(height: WkSpacing.md),

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
                    height: 1.4,
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

