/// Missions Map Widget for WorkOn.
///
/// Displays missions as pins on a Google Map.
/// Read-only: tap pin → navigate to MissionDetail.
///
/// **PR-F07:** Initial implementation.
/// **PR-MAP-SAFETY:** Hardened against missing permissions, invalid coords, empty data.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/client_part/mission_detail/mission_detail_widget.dart';
import '/config/app_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/location/location_service.dart';
import '/services/missions/mission_models.dart';

/// Widget displaying missions on a Google Map.
class MissionsMapWidget extends StatefulWidget {
  const MissionsMapWidget({
    super.key,
    required this.missions,
    this.onMissionTap,
  });

  /// List of missions to display as pins.
  final List<Mission> missions;

  /// Callback when a mission pin is tapped.
  final void Function(Mission mission)? onMissionTap;

  @override
  State<MissionsMapWidget> createState() => _MissionsMapWidgetState();
}

class _MissionsMapWidgetState extends State<MissionsMapWidget> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  String? _errorMessage;
  Set<Marker> _markers = {};
  
  /// PR-MAP-SAFETY: Track if map failed to load (Google services unavailable).
  bool _mapLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _initMarkers();
  }

  @override
  void didUpdateWidget(MissionsMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.missions != oldWidget.missions) {
      _initMarkers();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-MAP-SAFETY: Coordinate validation helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Checks if a coordinate value is valid (not null, not NaN, not 0).
  bool _isValidCoordinate(double? value) {
    if (value == null) return false;
    if (value.isNaN || value.isInfinite) return false;
    // 0,0 is in the ocean - likely invalid for missions
    return true;
  }

  /// Checks if a mission has valid coordinates for display on map.
  bool _hasValidCoordinates(Mission mission) {
    // Allow 0 values only if both are 0 (edge case) - but generally filter them
    if (mission.latitude == 0 && mission.longitude == 0) {
      debugPrint('[MissionsMap] Skipping mission ${mission.id}: coords are (0, 0)');
      return false;
    }
    return _isValidCoordinate(mission.latitude) && 
           _isValidCoordinate(mission.longitude);
  }

  /// Returns missions with valid coordinates only.
  List<Mission> get _validMissions {
    return widget.missions.where(_hasValidCoordinates).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Markers
  // ─────────────────────────────────────────────────────────────────────────

  void _initMarkers() {
    final validMissions = _validMissions;
    debugPrint('[MissionsMap] Initializing markers: ${validMissions.length} valid / ${widget.missions.length} total');
    
    final markers = <Marker>{};
    
    for (final mission in validMissions) {
      try {
        final marker = Marker(
          markerId: MarkerId(mission.id),
          position: LatLng(mission.latitude, mission.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(mission.status)),
          infoWindow: InfoWindow(
            title: mission.title,
            snippet: '${mission.formattedPrice} • ${mission.city}',
            onTap: () => _onMarkerTap(mission),
          ),
          onTap: () => _showMissionPreview(mission),
        );
        markers.add(marker);
      } catch (e) {
        debugPrint('[MissionsMap] Error creating marker for ${mission.id}: $e');
      }
    }

    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }

  /// Returns marker hue based on mission status.
  /// WorkOn Brand: Red pins for open missions (primary CTA).
  double _getMarkerHue(MissionStatus status) {
    switch (status) {
      case MissionStatus.open:
        return BitmapDescriptor.hueRed; // WorkOn Red - Available
      case MissionStatus.assigned:
        return BitmapDescriptor.hueOrange; // Assigned
      case MissionStatus.inProgress:
        return BitmapDescriptor.hueYellow; // In progress
      case MissionStatus.completed:
        return BitmapDescriptor.hueGreen; // Completed ✓
      case MissionStatus.paid:
        return BitmapDescriptor.hueCyan; // PR-6: Paid
      case MissionStatus.cancelled:
        return BitmapDescriptor.hueRose; // Cancelled
    }
  }

  void _onMarkerTap(Mission mission) {
    debugPrint('[MissionsMap] Marker info tapped: ${mission.id}');
    if (widget.onMissionTap != null) {
      widget.onMissionTap!(mission);
    } else {
      _navigateToDetail(mission);
    }
  }

  void _showMissionPreview(Mission mission) {
    debugPrint('[MissionsMap] Marker tapped: ${mission.id}');
    // The InfoWindow will show automatically
  }

  void _navigateToDetail(Mission mission) {
    context.pushNamed(
      MissionDetailWidget.routeName,
      queryParameters: {
        'missionId': mission.id,
      }.withoutNulls,
      extra: <String, dynamic>{
        'mission': mission,
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map controller
  // ─────────────────────────────────────────────────────────────────────────

  void _onMapCreated(GoogleMapController controller) {
    debugPrint('[MissionsMap] Map created');
    _mapController = controller;
    
    if (mounted) {
      setState(() {
        _isMapReady = true;
        _mapLoadFailed = false;
      });
    }

    // Fit bounds to show all markers if we have valid missions
    final validMissions = _validMissions;
    if (validMissions.isNotEmpty) {
      // Delay slightly to ensure map is fully ready
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _fitBounds();
      });
    }
  }

  void _fitBounds() {
    final validMissions = _validMissions;
    if (_mapController == null || validMissions.isEmpty) {
      debugPrint('[MissionsMap] fitBounds skipped: controller=${_mapController != null}, missions=${validMissions.length}');
      return;
    }

    final bounds = _calculateBounds();
    if (bounds == null) {
      debugPrint('[MissionsMap] fitBounds skipped: bounds calculation failed');
      return;
    }

    // PR-MAP-SAFETY: Wrap animateCamera in try-catch
    try {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      debugPrint('[MissionsMap] Error animating camera: $e');
      // Fallback: try moving to first mission
      try {
        final first = validMissions.first;
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(first.latitude, first.longitude),
            AppConfig.defaultMapZoom,
          ),
        );
      } catch (e2) {
        debugPrint('[MissionsMap] Fallback camera move also failed: $e2');
      }
    }
  }

  LatLngBounds? _calculateBounds() {
    final validMissions = _validMissions;
    
    // PR-MAP-SAFETY: Return null if no valid missions
    if (validMissions.isEmpty) {
      debugPrint('[MissionsMap] calculateBounds: no valid missions');
      return null;
    }

    // PR-MAP-SAFETY: Safe initialization with first valid mission
    double minLat = validMissions.first.latitude;
    double maxLat = validMissions.first.latitude;
    double minLng = validMissions.first.longitude;
    double maxLng = validMissions.first.longitude;

    for (final mission in validMissions) {
      if (mission.latitude < minLat) minLat = mission.latitude;
      if (mission.latitude > maxLat) maxLat = mission.latitude;
      if (mission.longitude < minLng) minLng = mission.longitude;
      if (mission.longitude > maxLng) maxLng = mission.longitude;
    }

    // PR-MAP-SAFETY: Validate calculated bounds
    if (minLat.isNaN || maxLat.isNaN || minLng.isNaN || maxLng.isNaN) {
      debugPrint('[MissionsMap] calculateBounds: invalid bounds (NaN)');
      return null;
    }

    // Add some padding
    const padding = 0.01;
    
    try {
      return LatLngBounds(
        southwest: LatLng(minLat - padding, minLng - padding),
        northeast: LatLng(maxLat + padding, maxLng + padding),
      );
    } catch (e) {
      debugPrint('[MissionsMap] calculateBounds error: $e');
      return null;
    }
  }

  /// PR-MAP-SAFETY: Get initial camera position safely.
  LatLng _getInitialTarget() {
    final validMissions = _validMissions;
    
    if (validMissions.isNotEmpty) {
      return LatLng(
        validMissions.first.latitude,
        validMissions.first.longitude,
      );
    }
    
    // Fallback: use cached user location if available, else default (Montreal)
    final userPos = LocationService.instance.cachedPosition;
    if (userPos != null) {
      return LatLng(userPos.latitude, userPos.longitude);
    }
    
    return LatLng(AppConfig.defaultMapLat, AppConfig.defaultMapLng);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Check if API key is configured
    if (!AppConfig.hasGoogleMapsKey) {
      return _buildNoApiKeyState(context);
    }

    // PR-MAP-SAFETY: Map load failure state
    if (_mapLoadFailed) {
      return _buildMapLoadFailedState(context);
    }

    // Error state
    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    // Empty state (no missions at all)
    if (widget.missions.isEmpty) {
      return _buildEmptyState(context);
    }

    // PR-MAP-SAFETY: All missions have invalid coords
    if (_validMissions.isEmpty) {
      return _buildNoValidCoordsState(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // PR-MAP-SAFETY: Wrap GoogleMap in error handler
          _buildGoogleMap(context),
          // Legend overlay
          Positioned(
            bottom: 8,
            left: 8,
            child: _buildLegend(context),
          ),
          // Fit bounds button
          Positioned(
            top: 8,
            right: 8,
            child: _buildFitBoundsButton(context),
          ),
          // PR-MAP-SAFETY: Location permission hint
          if (!LocationService.instance.hasPermission)
            Positioned(
              top: 8,
              left: 8,
              right: 48,
              child: _buildLocationHint(context),
            ),
        ],
      ),
    );
  }

  /// PR-MAP-SAFETY: Build Google Map with error handling.
  Widget _buildGoogleMap(BuildContext context) {
    try {
      return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _getInitialTarget(),
          zoom: AppConfig.defaultMapZoom,
        ),
        markers: _markers,
        // PR-F13: Enable user location indicator if permission granted.
        myLocationEnabled: LocationService.instance.hasPermission,
        myLocationButtonEnabled: LocationService.instance.hasPermission,
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
      );
    } catch (e) {
      debugPrint('[MissionsMap] Error building GoogleMap: $e');
      // Trigger rebuild with error state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _mapLoadFailed = true;
          });
        }
      });
      return _buildMapLoadFailedState(context);
    }
  }

  Widget _buildNoApiKeyState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Carte non disponible',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configuration requise',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// PR-MAP-SAFETY: Map load failed state with retry.
  Widget _buildMapLoadFailedState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Carte indisponible',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vérifie ta connexion et réessaie',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12),
            FFButtonWidget(
              onPressed: () {
                setState(() {
                  _mapLoadFailed = false;
                  _errorMessage = null;
                });
              },
              text: 'Réessayer',
              options: FFButtonOptions(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: FlutterFlowTheme.of(context).error,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Erreur de chargement',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12),
            FFButtonWidget(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _mapLoadFailed = false;
                });
                _initMarkers();
              },
              text: 'Réessayer',
              options: FFButtonOptions(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'General Sans',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Aucune mission à afficher',
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

  /// PR-MAP-SAFETY: State when all missions have invalid coordinates.
  Widget _buildNoValidCoordsState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wrong_location,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Positions non disponibles',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Les missions ne peuvent pas être affichées sur la carte',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// PR-MAP-SAFETY: Hint to enable location permission.
  Widget _buildLocationHint(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.shade100.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_disabled,
            size: 14,
            color: Colors.amber.shade800,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Active la localisation pour voir ta position',
              style: TextStyle(
                fontSize: 11,
                color: Colors.amber.shade900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendItem(context, Colors.green, 'Dispo'),
          const SizedBox(width: 8),
          _legendItem(context, Colors.blue, 'Assignée'),
          const SizedBox(width: 8),
          _legendItem(context, Colors.orange, 'En cours'),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFitBoundsButton(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: _fitBounds,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.fit_screen,
            size: 20,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      ),
    );
  }
}
