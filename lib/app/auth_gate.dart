/// Authentication gate widget for WorkOn.
///
/// Listens to [AppStartupController] and renders the appropriate screen
/// based on authentication state: loading, login, or home.
///
/// **PR#9:** UI auth gate wired to AppBootState.
library;

import 'package:flutter/material.dart';

import '/client_part/home/home_widget.dart';
import '/client_part/onboarding/onboarding_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/auth/app_boot_state.dart';
import '/services/auth/app_startup_controller.dart';

/// A widget that gates access to the app based on authentication state.
///
/// This widget:
/// - Shows a loading indicator while auth is being checked
/// - Shows [OnboardingWidget] (leads to login) when unauthenticated
/// - Shows [HomeWidget] when authenticated
///
/// ## Usage
///
/// Use as the initial route/home widget:
/// ```dart
/// MaterialApp(
///   home: const AuthGate(),
/// )
/// ```
class AuthGate extends StatefulWidget {
  /// Creates an [AuthGate].
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  /// The startup controller that manages boot state.
  late final AppStartupController _controller;

  /// Whether initialization has been triggered.
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AppStartupController();
    _initializeAuth();
  }

  /// Initializes the auth state asynchronously.
  Future<void> _initializeAuth() async {
    if (_initialized) return;
    _initialized = true;

    // Initialize the controller (triggers auth check)
    await _controller.initialize();

    // Force rebuild after initialization
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppBootState>(
      valueListenable: _controller.bootStateListenable,
      builder: (context, bootState, _) {
        switch (bootState.status) {
          case AppBootStatus.loading:
            return _buildLoadingScreen(context);

          case AppBootStatus.authenticated:
            return const HomeWidget();

          case AppBootStatus.unauthenticated:
            return const OnboardingWidget();
        }
      },
    );
  }

  /// Builds a minimal loading screen.
  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/images/Sparkly_Logo.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          ],
        ),
      ),
    );
  }
}

