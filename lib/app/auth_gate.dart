/// Authentication gate widget for WorkOn.
///
/// Listens to [AppStartupController] and renders the appropriate screen
/// based on authentication state: loading, login, or home.
///
/// **PR#9:** UI auth gate wired to AppBootState.
/// **PR-STATE:** Added networkError handling with banner.
library;

import 'package:flutter/material.dart';

import '/client_part/home/home_widget.dart';
import '/client_part/legal/legal_consent_gate.dart';
import '/client_part/onboarding/onboarding_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/auth/app_boot_state.dart';
import '/services/auth/app_startup_controller.dart';
import '/services/auth/auth_bootstrap.dart';
import '/services/auth/token_storage.dart';
import '/services/errors/error_handler.dart';

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
            // PR-V1-01: Wrap with LegalConsentGate to ensure consent before access
            return const LegalConsentGate(
              child: HomeWidget(),
            );

          case AppBootStatus.unauthenticated:
            return const OnboardingWidget();

          case AppBootStatus.networkError:
            // PR-STATE: Network error during bootstrap
            // If tokens exist, show home (optimistic) with network banner
            // Otherwise show onboarding
            return _buildNetworkErrorScreen(context);
        }
      },
    );
  }

  /// PR-STATE/F2: Builds screen for network error case.
  ///
  /// Shows a full-screen error with retry CTA instead of just a snackbar.
  /// If user has tokens, displays optimistic home with banner.
  /// If no tokens, shows dedicated error screen with retry.
  Widget _buildNetworkErrorScreen(BuildContext context) {
    // Check if we have tokens (user was previously logged in)
    final hasTokens = TokenStorage.hasToken;

    // If user had tokens, show home with a banner (optimistic)
    // This prevents logout on temporary network issues
    if (hasTokens) {
      // Show a snackbar after build for the optimistic case
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ErrorHandler.showMessage(
            WkCopy.errorNetwork,
            onRetry: _retryBootstrap,
          );
        }
      });
      // PR-V1-01: Wrap with LegalConsentGate
      return const LegalConsentGate(
        child: HomeWidget(),
      );
    }

    // No tokens - show dedicated error screen with retry CTA
    return _buildBootstrapErrorScreen(context);
  }

  /// PR-F2: Retries the bootstrap process safely.
  ///
  /// Resets the cached result and re-runs initialization.
  void _retryBootstrap() {
    if (!mounted) return;

    // Reset the cached bootstrap result to force a fresh attempt
    AuthBootstrap.reset();

    // Reset controller state
    _controller.dispose();
    _controller = AppStartupController();

    setState(() {
      _initialized = false;
    });
    _initializeAuth();
  }

  /// PR-F2: Builds a full-screen error for bootstrap failure (no tokens case).
  Widget _buildBootstrapErrorScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(WkSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    'assets/images/Sparkly_Logo.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: WkSpacing.xxl),

                // Error icon
                Icon(
                  Icons.wifi_off_rounded,
                  size: WkIconSize.xxxl,
                  color: WkStatusColors.cancelled,
                ),
                const SizedBox(height: WkSpacing.lg),

                // Error message
                Text(
                  WkCopy.errorNetwork,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                const SizedBox(height: WkSpacing.sm),
                Text(
                  WkCopy.bootstrapRetryHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: WkSpacing.xxl),

                // Retry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _retryBootstrap,
                    icon: const Icon(Icons.refresh),
                    label: Text(WkCopy.retry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: WkSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(WkRadius.button),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

