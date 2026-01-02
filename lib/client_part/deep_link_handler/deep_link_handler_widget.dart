/// Deep link handler screen for WorkOn.
///
/// Intermediate screen that processes deep links and navigates
/// to the correct destination.
///
/// **PR-21:** Deep links handling.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/analytics/analytics_service.dart';
import '/services/deep_linking/deep_link_service.dart';
import '/services/missions/missions_service.dart';
import '/services/users/users_service.dart';
import '/client_part/mission_detail/mission_detail_widget.dart';
import '/client_part/deep_link_error/deep_link_error_widget.dart';

/// Handler for mission deep links.
///
/// Loads mission and navigates to detail page or shows error.
class MissionDeepLinkHandler extends StatefulWidget {
  const MissionDeepLinkHandler({
    super.key,
    required this.missionId,
  });

  final String missionId;

  static String routeName = 'MissionDeepLink';
  static String routePath = '/mission/:missionId';

  @override
  State<MissionDeepLinkHandler> createState() => _MissionDeepLinkHandlerState();
}

class _MissionDeepLinkHandlerState extends State<MissionDeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    // PR-23: Track deep link opened
    AnalyticsService.trackDeepLinkOpened(
      linkType: 'mission',
      targetId: widget.missionId,
    );
    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    // Small delay to allow screen to build
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    try {
      // Try to load the mission
      final mission = await MissionsService.getById(widget.missionId);

      if (!mounted) return;

      if (mission != null) {
        // Navigate to mission detail
        context.pushReplacementNamed(
          MissionDetailWidget.routeName,
          pathParameters: {'missionId': widget.missionId},
          extra: {'mission': mission},
        );
      } else {
        // Mission not found
        _showError(DeepLinkErrorType.missionNotFound);
      }
    } catch (e) {
      debugPrint('[MissionDeepLinkHandler] Error loading mission: $e');
      if (!mounted) return;
      _showError(DeepLinkErrorType.networkError);
    }
  }

  void _showError(DeepLinkErrorType errorType) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DeepLinkErrorWidget(
          errorType: errorType,
          resourceId: widget.missionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }
}

/// Handler for profile deep links.
///
/// Loads user profile and navigates to appropriate profile page.
class ProfileDeepLinkHandler extends StatefulWidget {
  const ProfileDeepLinkHandler({
    super.key,
    required this.userId,
  });

  final String userId;

  static String routeName = 'ProfileDeepLink';
  static String routePath = '/profile/:userId';

  @override
  State<ProfileDeepLinkHandler> createState() => _ProfileDeepLinkHandlerState();
}

class _ProfileDeepLinkHandlerState extends State<ProfileDeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    // PR-23: Track deep link opened
    AnalyticsService.trackDeepLinkOpened(
      linkType: 'profile',
      targetId: widget.userId,
    );
    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    // Small delay to allow screen to build
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    try {
      // Try to load the user
      final user = await UsersService.getUserById(widget.userId);

      if (!mounted) return;

      if (user != null) {
        // Navigate to appropriate profile based on user type
        // For now, we'll use the AllReviews page which accepts userId
        context.pushReplacementNamed(
          'AllReviews',
          queryParameters: {'userId': widget.userId},
        );
      } else {
        // Profile not found
        _showError(DeepLinkErrorType.profileNotFound);
      }
    } catch (e) {
      debugPrint('[ProfileDeepLinkHandler] Error loading profile: $e');
      if (!mounted) return;
      _showError(DeepLinkErrorType.networkError);
    }
  }

  void _showError(DeepLinkErrorType errorType) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DeepLinkErrorWidget(
          errorType: errorType,
          resourceId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Chargement du profil...',
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
}

/// Handler for invite deep links.
///
/// Saves attribution data and redirects to onboarding/home.
class InviteDeepLinkHandler extends StatefulWidget {
  const InviteDeepLinkHandler({
    super.key,
    this.referralCode,
    this.utmSource,
    this.utmCampaign,
    this.utmMedium,
  });

  final String? referralCode;
  final String? utmSource;
  final String? utmCampaign;
  final String? utmMedium;

  static String routeName = 'InviteDeepLink';
  static String routePath = '/invite';

  @override
  State<InviteDeepLinkHandler> createState() => _InviteDeepLinkHandlerState();
}

class _InviteDeepLinkHandlerState extends State<InviteDeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    // PR-23: Track deep link opened with UTM params
    AnalyticsService.trackDeepLinkOpened(
      linkType: 'invite',
      targetId: widget.referralCode,
      utmParams: {
        if (widget.utmSource != null) 'utm_source': widget.utmSource!,
        if (widget.utmCampaign != null) 'utm_campaign': widget.utmCampaign!,
        if (widget.utmMedium != null) 'utm_medium': widget.utmMedium!,
      },
    );
    _processAndNavigate();
  }

  Future<void> _processAndNavigate() async {
    // Save attribution data
    final attribution = Attribution(
      referralCode: widget.referralCode,
      utmSource: widget.utmSource,
      utmCampaign: widget.utmCampaign,
      utmMedium: widget.utmMedium,
      timestamp: DateTime.now(),
    );

    await DeepLinkService.saveAttribution(attribution);
    
    // PR-23: Load attribution for future events
    await AnalyticsService.loadAttribution();

    if (!mounted) return;

    // Navigate to home (AuthGate will handle auth state)
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WorkOn logo placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE24A33).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                size: 40,
                color: Color(0xFFE24A33),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bienvenue sur WorkOn!',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 8),
            if (widget.referralCode != null) ...[
              Text(
                'Invitation de: ${widget.referralCode}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 16),
            ],
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          ],
        ),
      ),
    );
  }
}

