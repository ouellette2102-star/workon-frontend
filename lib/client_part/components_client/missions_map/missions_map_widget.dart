/// Missions Map Widget for WorkOn.
///
/// Displays missions as pins on a Google Map.
/// Read-only: tap pin → navigate to MissionDetail.
///
/// **PR-F07:** Initial implementation.
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

  void _initMarkers() {
    debugPrint('[MissionsMap] Initializing ${widget.missions.length} markers');
    
    final markers = <Marker>{};
    
    for (final mission in widget.missions) {
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
    }

    setState(() {
      _markers = markers;
    });
  }

  /// Returns marker hue based on mission status.
  double _getMarkerHue(MissionStatus status) {
    switch (status) {
      case MissionStatus.open:
        return BitmapDescriptor.hueGreen; // Available
      case MissionStatus.assigned:
        return BitmapDescriptor.hueAzure; // Assigned
      case MissionStatus.inProgress:
        return BitmapDescriptor.hueOrange; // In progress
      case MissionStatus.completed:
        return BitmapDescriptor.hueViolet; // Completed
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

  void _onMapCreated(GoogleMapController controller) {
    debugPrint('[MissionsMap] Map created');
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });

    // Fit bounds to show all markers if we have missions
    if (widget.missions.isNotEmpty) {
      _fitBounds();
    }
  }

  void _fitBounds() {
    if (_mapController == null || widget.missions.isEmpty) return;

    final bounds = _calculateBounds();
    if (bounds != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds? _calculateBounds() {
    if (widget.missions.isEmpty) return null;

    double minLat = widget.missions.first.latitude;
    double maxLat = widget.missions.first.latitude;
    double minLng = widget.missions.first.longitude;
    double maxLng = widget.missions.first.longitude;

    for (final mission in widget.missions) {
      if (mission.latitude < minLat) minLat = mission.latitude;
      if (mission.latitude > maxLat) maxLat = mission.latitude;
      if (mission.longitude < minLng) minLng = mission.longitude;
      if (mission.longitude > maxLng) maxLng = mission.longitude;
    }

    // Add some padding
    const padding = 0.01;
    return LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if API key is configured
    if (!AppConfig.hasGoogleMapsKey) {
      return _buildNoApiKeyState(context);
    }

    // Error state
    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    // Empty state
    if (widget.missions.isEmpty) {
      return _buildEmptyState(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.missions.isNotEmpty
                    ? widget.missions.first.latitude
                    : AppConfig.defaultMapLat,
                widget.missions.isNotEmpty
                    ? widget.missions.first.longitude
                    : AppConfig.defaultMapLng,
              ),
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
          ),
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
        ],
      ),
    );
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
            SizedBox(height: 12),
            Text(
              'Carte non disponible',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 4),
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
            SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Erreur de chargement',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 12),
            FFButtonWidget(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _initMarkers();
              },
              text: 'Réessayer',
              options: FFButtonOptions(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            SizedBox(height: 12),
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

  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          SizedBox(width: 8),
          _legendItem(context, Colors.blue, 'Assignée'),
          SizedBox(width: 8),
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
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
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
          padding: EdgeInsets.all(8),
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

