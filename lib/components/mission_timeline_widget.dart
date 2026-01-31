/// Mission timeline widget.
///
/// Displays the event history of a mission.
///
/// **FL-EVENTS:** Initial implementation.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/mission_events/mission_events_api.dart';

/// Widget showing mission event timeline.
class MissionTimelineWidget extends StatefulWidget {
  const MissionTimelineWidget({
    super.key,
    required this.missionId,
    this.compact = false,
  });

  /// Mission ID to show events for.
  final String missionId;

  /// Whether to show in compact mode.
  final bool compact;

  @override
  State<MissionTimelineWidget> createState() => _MissionTimelineWidgetState();
}

class _MissionTimelineWidgetState extends State<MissionTimelineWidget> {
  static const _api = MissionEventsApi();

  bool _isLoading = true;
  String? _errorMessage;
  List<MissionEvent> _events = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.getMissionEvents(
        widget.missionId,
        limit: widget.compact ? 5 : 20,
      );

      if (mounted) {
        setState(() {
          _events = response.events;
          _nextCursor = response.nextCursor;
          _hasMore = response.hasMore;
          _isLoading = false;
        });
      }
    } on MissionEventsApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[MissionTimeline] Error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les événements';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _nextCursor == null) return;

    setState(() => _isLoadingMore = true);

    try {
      final response = await _api.getMissionEvents(
        widget.missionId,
        limit: 20,
        cursor: _nextCursor,
      );

      if (mounted) {
        setState(() {
          _events.addAll(response.events);
          _nextCursor = response.nextCursor;
          _hasMore = response.hasMore;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(color: theme.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: theme.error, size: 32),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: theme.bodySmall.override(
                  fontFamily: 'General Sans',
                  color: theme.error,
                  letterSpacing: 0,
                ),
              ),
              TextButton(
                onPressed: _loadEvents,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Aucun événement',
            style: theme.bodyMedium.override(
              fontFamily: 'General Sans',
              color: theme.secondaryText,
              letterSpacing: 0,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.compact)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Historique',
              style: theme.titleSmall.override(
                fontFamily: 'General Sans',
                letterSpacing: 0,
              ),
            ),
          ),
        ..._events.map((event) => _buildEventRow(theme, event)),
        if (_hasMore && !widget.compact)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: _isLoadingMore
                  ? CircularProgressIndicator(color: theme.primary)
                  : TextButton(
                      onPressed: _loadMore,
                      child: const Text('Voir plus'),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildEventRow(FlutterFlowTheme theme, MissionEvent event) {
    final dateFormat = DateFormat('d MMM, HH:mm', 'fr_FR');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getEventColor(theme, event.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getEventIcon(event.type),
                  size: 16,
                  color: _getEventColor(theme, event.type),
                ),
              ),
              Container(
                width: 2,
                height: 24,
                color: theme.alternate,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.type.displayName,
                  style: theme.bodyMedium.override(
                    fontFamily: 'General Sans',
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormat.format(event.createdAt),
                  style: theme.bodySmall.override(
                    fontFamily: 'General Sans',
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  ),
                ),
                if (event.payload != null && event.payload!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildPayloadInfo(theme, event.payload!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadInfo(FlutterFlowTheme theme, Map<String, dynamic> payload) {
    String? info;

    if (payload.containsKey('fromStatus') && payload.containsKey('toStatus')) {
      info = '${payload['fromStatus']} → ${payload['toStatus']}';
    } else if (payload.containsKey('amount')) {
      info = '${payload['amount']} \$';
    } else if (payload.containsKey('reason')) {
      info = payload['reason'] as String?;
    }

    if (info == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.alternate.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        info,
        style: theme.bodySmall.override(
          fontFamily: 'General Sans',
          fontSize: 11,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Color _getEventColor(FlutterFlowTheme theme, MissionEventType type) {
    switch (type) {
      case MissionEventType.missionCreated:
      case MissionEventType.missionPublished:
        return theme.primary;
      case MissionEventType.missionAccepted:
      case MissionEventType.missionStarted:
        return theme.success;
      case MissionEventType.missionCompleted:
        return theme.success;
      case MissionEventType.missionCanceled:
      case MissionEventType.missionExpired:
        return theme.error;
      case MissionEventType.paymentAuthorized:
      case MissionEventType.paymentCaptured:
        return theme.success;
      case MissionEventType.paymentCanceled:
        return theme.warning;
      case MissionEventType.photoUploaded:
        return theme.tertiary;
      case MissionEventType.offerSubmitted:
        return theme.primary;
      case MissionEventType.offerAccepted:
        return theme.success;
      case MissionEventType.offerDeclined:
        return theme.error;
    }
  }

  IconData _getEventIcon(MissionEventType type) {
    switch (type) {
      case MissionEventType.missionCreated:
        return Icons.add_circle_outline_rounded;
      case MissionEventType.missionPublished:
        return Icons.publish_rounded;
      case MissionEventType.missionAccepted:
        return Icons.handshake_rounded;
      case MissionEventType.missionStarted:
        return Icons.play_circle_outline_rounded;
      case MissionEventType.missionCompleted:
        return Icons.check_circle_outline_rounded;
      case MissionEventType.missionCanceled:
        return Icons.cancel_outlined;
      case MissionEventType.missionExpired:
        return Icons.timer_off_outlined;
      case MissionEventType.paymentAuthorized:
        return Icons.lock_outline_rounded;
      case MissionEventType.paymentCaptured:
        return Icons.payments_outlined;
      case MissionEventType.paymentCanceled:
        return Icons.money_off_rounded;
      case MissionEventType.photoUploaded:
        return Icons.photo_camera_outlined;
      case MissionEventType.offerSubmitted:
        return Icons.send_rounded;
      case MissionEventType.offerAccepted:
        return Icons.thumb_up_outlined;
      case MissionEventType.offerDeclined:
        return Icons.thumb_down_outlined;
    }
  }
}
