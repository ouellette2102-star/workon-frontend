/// Swipe Discovery Page for WorkOn.
///
/// Tinder-style swipe interface for discovering missions.
/// Swipe right = View details / Interested
/// Swipe left = Skip / Not interested
///
/// **PR-DISCOVERY:** Initial implementation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/app_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/discovery/discovery_service.dart';
import '/services/missions/mission_models.dart';

/// Route name for navigation.
class SwipeDiscoveryPage extends StatefulWidget {
  const SwipeDiscoveryPage({super.key});

  static const String routeName = 'SwipeDiscoveryPage';
  static const String routePath = '/discover/swipe';

  @override
  State<SwipeDiscoveryPage> createState() => _SwipeDiscoveryPageState();
}

class _SwipeDiscoveryPageState extends State<SwipeDiscoveryPage> {
  final CardSwiperController _controller = CardSwiperController();
  final DiscoveryService _discovery = DiscoveryService.instance;

  @override
  void initState() {
    super.initState();
    _discovery.addListener(_onDiscoveryChanged);
    _loadMissions();
  }

  @override
  void dispose() {
    _discovery.removeListener(_onDiscoveryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onDiscoveryChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadMissions() async {
    await _discovery.loadNearby();
  }

  void _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final missions = _discovery.swipeableMissions;
    if (previousIndex >= missions.length) return;

    final mission = missions[previousIndex];

    if (direction == CardSwiperDirection.right) {
      // Swipe right = Interested → Open details
      debugPrint('[SwipeDiscovery] Interested in: ${mission.title}');
      _openMissionDetail(mission);
    } else if (direction == CardSwiperDirection.left) {
      // Swipe left = Skip
      debugPrint('[SwipeDiscovery] Skipped: ${mission.title}');
      _discovery.ignoreMission(mission.id);
    }
  }

  void _openMissionDetail(Mission mission) {
    context.pushNamed(
      MissionDetailWidget.routeName,
      queryParameters: {'missionId': mission.id}.withoutNulls,
      extra: <String, dynamic>{'mission': mission},
    );
  }

  void _openMapView() {
    context.pushReplacementNamed('MapDiscoveryPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Découvrir',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'General Sans',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          // Map toggle button
          IconButton(
            icon: Icon(
              Icons.map_outlined,
              color: FlutterFlowTheme.of(context).primary,
            ),
            tooltip: 'Vue carte',
            onPressed: AppConfig.discoveryMap ? _openMapView : null,
          ),
          // Refresh button
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            onPressed: () {
              _discovery.clearIgnored();
              _discovery.refresh();
            },
          ),
        ],
      ),
      body: _buildBody(context),
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
        final missions = _discovery.swipeableMissions;
        if (missions.isEmpty) {
          return _buildAllSwipedState(context);
        }
        return _buildSwipeView(context, missions);
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
            'Chargement des missions...',
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
              Icons.search_off,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune mission à proximité',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Élargis ton rayon de recherche ou reviens plus tard',
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

  Widget _buildAllSwipedState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Tu as tout vu!',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reviens plus tard pour de nouvelles missions',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () {
                    _discovery.clearIgnored();
                  },
                  text: 'Revoir',
                  options: FFButtonOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          letterSpacing: 0.0,
                        ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                FFButtonWidget(
                  onPressed: () => _discovery.refresh(),
                  text: 'Actualiser',
                  options: FFButtonOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  Widget _buildSwipeView(BuildContext context, List<Mission> missions) {
    return Column(
      children: [
        // Swipe hint
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.swipe_left, size: 16, color: FlutterFlowTheme.of(context).error),
                  const SizedBox(width: 4),
                  Text(
                    'Passer',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
              Text(
                '${missions.length} missions',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
              ),
              Row(
                children: [
                  Text(
                    'Voir détails',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.swipe_right, size: 16, color: FlutterFlowTheme.of(context).primary),
                ],
              ),
            ],
          ),
        ),

        // Swipe cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CardSwiper(
              controller: _controller,
              cardsCount: missions.length,
              numberOfCardsDisplayed: missions.length.clamp(1, 3),
              onSwipe: (prev, curr, dir) {
                _onSwipe(prev, curr, dir);
                return true;
              },
              padding: const EdgeInsets.symmetric(vertical: 16),
              cardBuilder: (context, index, percentX, percentY) {
                if (index >= missions.length) return const SizedBox();
                return _MissionCard(
                  mission: missions[index],
                  onTap: () => _openMissionDetail(missions[index]),
                );
              },
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Skip button
              _ActionButton(
                icon: Icons.close,
                color: FlutterFlowTheme.of(context).error,
                onTap: () => _controller.swipe(CardSwiperDirection.left),
              ),
              // Info button (tap to see details)
              _ActionButton(
                icon: Icons.info_outline,
                color: FlutterFlowTheme.of(context).secondary,
                size: 48,
                onTap: () {
                  if (missions.isNotEmpty) {
                    _openMissionDetail(missions.first);
                  }
                },
              ),
              // Like button
              _ActionButton(
                icon: Icons.favorite,
                color: FlutterFlowTheme.of(context).primary,
                onTap: () => _controller.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mission Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.mission,
    required this.onTap,
  });

  final Mission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category color
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  // Category badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryLabel(mission.category),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(mission.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        mission.status.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Price
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mission.formattedPrice,
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      mission.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            mission.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'General Sans',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        if (mission.distanceKm != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${mission.distanceKm!.toStringAsFixed(1)} km',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Expanded(
                      child: Text(
                        mission.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),

                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(mission.createdAt),
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tap hint
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Appuie pour voir les détails',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'snow_removal':
        return 'Déneigement';
      case 'cleaning':
        return 'Ménage';
      case 'gardening':
        return 'Jardinage';
      case 'moving':
        return 'Déménagement';
      case 'delivery':
        return 'Livraison';
      case 'handyman':
        return 'Bricolage';
      default:
        return category;
    }
  }

  Color _getStatusColor(MissionStatus status) {
    switch (status) {
      case MissionStatus.open:
        return Colors.green;
      case MissionStatus.assigned:
        return Colors.blue;
      case MissionStatus.inProgress:
        return Colors.orange;
      case MissionStatus.completed:
        return Colors.purple;
      case MissionStatus.paid:
        return Colors.teal;
      case MissionStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return "Aujourd'hui";
    } else if (diff.inDays == 1) {
      return 'Hier';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button Widget
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 56,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}

