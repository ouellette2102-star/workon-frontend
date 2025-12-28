import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import '/services/missions/missions_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mission_detail_model.dart';
export 'mission_detail_model.dart';

/// Read-only mission detail page.
///
/// Displays mission information without any write actions.
///
/// **PR-F05b:** Initial implementation.
/// **PR-F06:** Real data fetch + retry on error + improved logging.
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MissionDetailModel());

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
                  'Détails mission',
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
            SizedBox(height: 16),
            Text(
              'Chargement...',
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: FlutterFlowTheme.of(context).error,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Mission introuvable',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 20),
              // PR-F06: Retry button (only if we have an ID to retry with)
              if (widget.missionId.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: FFButtonWidget(
                    onPressed: _loadMission,
                    text: 'Réessayer',
                    options: FFButtonOptions(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                          ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              FFButtonWidget(
                onPressed: () => context.pop(),
                text: 'Retour',
                options: FFButtonOptions(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: Colors.transparent,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                  borderRadius: BorderRadius.circular(12),
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(context, mission),
            SizedBox(height: 20),

            // Description section
            _buildSection(
              context,
              title: 'Description',
              child: Text(
                mission.description.isNotEmpty
                    ? mission.description
                    : 'Aucune description fournie.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      letterSpacing: 0.0,
                      height: 1.5,
                    ),
              ),
            ),
            SizedBox(height: 20),

            // Location section
            _buildSection(
              context,
              title: 'Localisation',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.location_city,
                    label: 'Ville',
                    value: mission.city,
                  ),
                  if (mission.address != null && mission.address!.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on,
                      label: 'Adresse',
                      value: mission.address!,
                    ),
                  _buildInfoRow(
                    context,
                    icon: Icons.my_location,
                    label: 'Coordonnées',
                    value:
                        '${mission.latitude.toStringAsFixed(4)}, ${mission.longitude.toStringAsFixed(4)}',
                  ),
                  if (mission.distanceKm != null)
                    _buildInfoRow(
                      context,
                      icon: Icons.straighten,
                      label: 'Distance',
                      value: mission.formattedDistance ?? '',
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Details section
            _buildSection(
              context,
              title: 'Informations',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.category,
                    label: 'Catégorie',
                    value: _formatCategory(mission.category),
                  ),
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Publiée le',
                    value: _formatDate(mission.createdAt),
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
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
          SizedBox(height: 12),

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
          SizedBox(height: 8),

          // Location
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white70, size: 18),
              SizedBox(width: 6),
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
          SizedBox(height: 16),

          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget',
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
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
          SizedBox(height: 12),
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
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
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
}

