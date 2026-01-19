/// Map Discovery Page for WorkOn.
///
/// Airbnb-style map interface for discovering missions.
/// Uses Google Maps with mission pins.
/// Tap pin → See preview → Open details.
///
/// **PR-DISCOVERY:** Initial implementation.
library;

import 'package:flutter/material.dart';

import '/client_part/components_client/missions_map/missions_map_widget.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/app_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/discovery/discovery_service.dart';
import '/services/missions/mission_models.dart';

/// Route name for navigation.
class MapDiscoveryPage extends StatefulWidget {
  const MapDiscoveryPage({super.key});

  static const String routeName = 'MapDiscoveryPage';
  static const String routePath = '/discover/map';

  @override
  State<MapDiscoveryPage> createState() => _MapDiscoveryPageState();
}

class _MapDiscoveryPageState extends State<MapDiscoveryPage> {
  final DiscoveryService _discovery = DiscoveryService.instance;
  Mission? _selectedMission;

  @override
  void initState() {
    super.initState();
    _discovery.addListener(_onDiscoveryChanged);
    _loadMissions();
  }

  @override
  void dispose() {
    _discovery.removeListener(_onDiscoveryChanged);
    super.dispose();
  }

  void _onDiscoveryChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadMissions() async {
    await _discovery.loadNearby();
  }

  void _onMissionTap(Mission mission) {
    setState(() {
      _selectedMission = mission;
    });
  }

  void _openMissionDetail(Mission mission) {
    context.pushNamed(
      MissionDetailWidget.routeName,
      queryParameters: {'missionId': mission.id}.withoutNulls,
      extra: <String, dynamic>{'mission': mission},
    );
  }

  void _openSwipeView() {
    context.pushReplacementNamed('SwipeDiscoveryPage');
  }

  void _closePreview() {
    setState(() {
      _selectedMission = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          // Map or content
          _buildBody(context),

          // Top bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FlutterFlowTheme.of(context).primaryBackground,
                    FlutterFlowTheme.of(context).primaryBackground.withOpacity(0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Back button
                  _CircleButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  // Title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      '${_discovery.count} missions',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  const Spacer(),
                  // Swipe toggle button
                  _CircleButton(
                    icon: Icons.swipe,
                    onTap: AppConfig.discoverySwipe ? _openSwipeView : null,
                  ),
                ],
              ),
            ),
          ),

          // Bottom preview card
          if (_selectedMission != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
              child: _MissionPreviewCard(
                mission: _selectedMission!,
                onTap: () => _openMissionDetail(_selectedMission!),
                onClose: _closePreview,
              ),
            ),

          // Refresh FAB (when no preview shown)
          if (_selectedMission == null)
            Positioned(
              right: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
              child: FloatingActionButton.small(
                heroTag: 'refresh',
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                onPressed: () => _discovery.refresh(),
                child: Icon(
                  Icons.refresh,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_discovery.state) {
      case DiscoveryState.loading:
        return _buildLoadingState(context);
      case DiscoveryState.error:
        return _buildErrorState(context);
      case DiscoveryState.empty:
        return _buildEmptyState(context);
      case DiscoveryState.ready:
      case DiscoveryState.idle:
        if (_discovery.missions.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildMapView(context);
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement de la carte...',
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).error,
            ),
            const SizedBox(height: 16),
            Text(
              _discovery.errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 24),
            FFButtonWidget(
              onPressed: _loadMissions,
              text: 'Réessayer',
              options: FFButtonOptions(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune mission à afficher',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essaie d\'élargir ta zone de recherche',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 24),
            FFButtonWidget(
              onPressed: () => _discovery.refresh(),
              text: 'Actualiser',
              options: FFButtonOptions(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
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

  Widget _buildMapView(BuildContext context) {
    return MissionsMapWidget(
      missions: _discovery.missions,
      onMissionTap: _onMissionTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circle Button Widget
// ─────────────────────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null
              ? FlutterFlowTheme.of(context).primaryText
              : FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mission Preview Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _MissionPreviewCard extends StatelessWidget {
  const _MissionPreviewCard({
    required this.mission,
    required this.onTap,
    required this.onClose,
  });

  final Mission mission;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(mission.category),
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Title and location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'General Sans',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mission.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'General Sans',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          if (mission.distanceKm != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${mission.distanceKm!.toStringAsFixed(1)} km',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Price and CTA
            Row(
              children: [
                // Price
                Text(
                  mission.formattedPrice,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'General Sans',
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                const Spacer(),
                // View button
                FFButtonWidget(
                  onPressed: onTap,
                  text: 'Voir détails',
                  options: FFButtonOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'snow_removal':
        return Icons.ac_unit;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'gardening':
        return Icons.grass;
      case 'moving':
        return Icons.local_shipping;
      case 'delivery':
        return Icons.delivery_dining;
      case 'handyman':
        return Icons.handyman;
      default:
        return Icons.work;
    }
  }
}

