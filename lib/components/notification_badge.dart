/// Notification badge widget for WorkOn.
///
/// **PR-FIX-04:** Displays dynamic notification count badge.
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/notifications/notification_count_service.dart';

/// Notification bell icon with dynamic unread badge.
///
/// Usage:
/// ```dart
/// NotificationBadge(
///   onTap: () => context.pushNamed(NotificationsWidget.routeName),
/// )
/// ```
class NotificationBadge extends StatefulWidget {
  const NotificationBadge({
    super.key,
    required this.onTap,
    this.iconSize = 26.0,
    this.badgeSize = 10.0,
    this.showCount = false,
  });

  /// Called when the bell icon is tapped.
  final VoidCallback onTap;

  /// Size of the bell icon.
  final double iconSize;

  /// Size of the badge dot.
  final double badgeSize;

  /// Whether to show count number (for counts > 0).
  /// If false, shows a simple red dot.
  final bool showCount;

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  int _count = NotificationCountService.count;

  @override
  void initState() {
    super.initState();
    // Subscribe to count changes
    NotificationCountService.stream.listen(_onCountChanged);
    // Initialize if not done yet
    NotificationCountService.initialize();
  }

  void _onCountChanged(int count) {
    if (mounted) {
      setState(() => _count = count);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // Bell icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_outlined,
              color: theme.primaryText,
              size: widget.iconSize,
            ),
          ),

          // Badge (only shown when count > 0)
          if (_count > 0)
            Positioned(
              top: 6.0,
              right: 6.0,
              child: widget.showCount && _count > 0
                  ? _buildCountBadge(theme)
                  : _buildDotBadge(theme),
            ),
        ],
      ),
    );
  }

  Widget _buildDotBadge(FlutterFlowTheme theme) {
    return Container(
      width: widget.badgeSize,
      height: widget.badgeSize,
      decoration: BoxDecoration(
        color: theme.error,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.primaryBackground,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _buildCountBadge(FlutterFlowTheme theme) {
    final displayCount = _count > 99 ? '99+' : _count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      decoration: BoxDecoration(
        color: theme.error,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.primaryBackground,
          width: 1.5,
        ),
      ),
      child: Text(
        displayCount,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

