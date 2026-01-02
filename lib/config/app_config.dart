/// Centralized application configuration for WorkOn.
///
/// This file contains all environment-specific settings including
/// backend API URLs for Railway deployment.
///
/// **PR-G2:** Added AppEnv enum, safety guards, and environment badge.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PR-G2: Environment Enum
// ─────────────────────────────────────────────────────────────────────────────

/// Application environment.
enum AppEnv {
  /// Development environment (local/dev backend).
  dev,

  /// Staging environment (pre-prod testing).
  staging,

  /// Production environment (live users).
  prod;

  /// Parses environment from string (case-insensitive).
  static AppEnv fromName(String name) {
    switch (name.toLowerCase()) {
      case 'dev':
      case 'development':
        return AppEnv.dev;
      case 'staging':
      case 'stage':
        return AppEnv.staging;
      case 'prod':
      case 'production':
      default:
        return AppEnv.prod;
    }
  }

  /// Short label for badge display.
  String get label {
    switch (this) {
      case AppEnv.dev:
        return 'DEV';
      case AppEnv.staging:
        return 'STAGING';
      case AppEnv.prod:
        return '';
    }
  }

  /// Badge color.
  Color get badgeColor {
    switch (this) {
      case AppEnv.dev:
        return const Color(0xFFEF4444); // Red
      case AppEnv.staging:
        return const Color(0xFFF59E0B); // Amber
      case AppEnv.prod:
        return Colors.transparent;
    }
  }
}

/// Application configuration class providing centralized access
/// to all environment-specific settings.
abstract final class AppConfig {
  // ─────────────────────────────────────────────────────────────────────────
  // PR-G2: Environment Selection (Single Source of Truth)
  // ─────────────────────────────────────────────────────────────────────────

  /// Environment name from compile-time define.
  /// Set via: --dart-define=APP_ENV=dev|staging|prod
  static const String _envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
  );

  /// Current application environment.
  static final AppEnv env = AppEnv.fromName(_envName);

  /// Returns `true` if running in production environment.
  static bool get isProd => env == AppEnv.prod;

  /// Returns `true` if running in development environment.
  static bool get isDev => env == AppEnv.dev;

  /// Returns `true` if running in staging environment.
  static bool get isStaging => env == AppEnv.staging;

  // ─────────────────────────────────────────────────────────────────────────
  // Backend API Configuration (Railway)
  // ─────────────────────────────────────────────────────────────────────────

  /// Production backend API base URL hosted on Railway.
  static const String _apiBaseUrlProd =
      'https://workon-backend-production.up.railway.app';

  /// Staging backend API base URL.
  /// NOTE: Points to production until a separate staging backend is deployed.
  static const String _apiBaseUrlStaging =
      'https://workon-backend-production.up.railway.app';

  /// Development backend API base URL.
  /// NOTE: Points to production until a separate dev backend is deployed.
  static const String _apiBaseUrlDev =
      'https://workon-backend-production.up.railway.app';

  /// API base URL from compile-time define (overrides env-based selection).
  /// Set via: --dart-define=API_BASE_URL=https://...
  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Current active API URL based on environment or explicit override.
  static String get activeApiUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _apiBaseUrlOverride;
    }
    switch (env) {
      case AppEnv.dev:
        return _apiBaseUrlDev;
      case AppEnv.staging:
        return _apiBaseUrlStaging;
      case AppEnv.prod:
        return _apiBaseUrlProd;
    }
  }

  // Legacy aliases for backward compatibility
  static String get apiBaseUrl => _apiBaseUrlProd;
  static String get apiBaseUrlDev => _apiBaseUrlDev;

  // ─────────────────────────────────────────────────────────────────────────
  // Environment Configuration (Legacy - kept for compatibility)
  // ─────────────────────────────────────────────────────────────────────────

  /// Flag indicating whether the app is running in production mode.
  /// Set to `true` for release builds.
  static const bool _isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  /// Returns `true` if running in production environment.
  static bool get isProduction => _isProduction || isProd;

  /// Returns `true` if running in development environment.
  static bool get isDevelopment => !isProduction;

  // ─────────────────────────────────────────────────────────────────────────
  // PR-G2: Safety Guards
  // ─────────────────────────────────────────────────────────────────────────

  /// Known production URL patterns.
  static const List<String> _prodUrlPatterns = [
    'workon-backend-production',
    'workon.app',
    'railway.app',
  ];

  /// Known dev/local URL patterns.
  static const List<String> _devUrlPatterns = [
    'localhost',
    '127.0.0.1',
    '10.0.2.2', // Android emulator localhost
    'ngrok',
    '-dev.',
    '-staging.',
  ];

  /// Validates environment configuration and asserts safety in debug mode.
  ///
  /// Call this early in main() to catch misconfigurations.
  /// In release mode, this is a no-op (no crashes).
  static void validateConfiguration() {
    // Only enforce in debug/profile mode
    if (kReleaseMode) return;

    final url = activeApiUrl.toLowerCase();
    final isProdUrl = _prodUrlPatterns.any((p) => url.contains(p));
    final isDevUrl = _devUrlPatterns.any((p) => url.contains(p));

    // Guard: PROD env with DEV url
    if (env == AppEnv.prod && isDevUrl) {
      assert(
        false,
        '[AppConfig] SAFETY VIOLATION: APP_ENV=prod but API_BASE_URL points to a dev host ($url). '
        'This is likely a misconfiguration. Use APP_ENV=dev or fix API_BASE_URL.',
      );
    }

    // Guard: DEV/STAGING env with PROD url (warning, not fatal)
    if (env != AppEnv.prod && isProdUrl && !isDevUrl) {
      debugPrint(
        '[AppConfig] ⚠️ WARNING: APP_ENV=${env.name} but API_BASE_URL points to production ($url). '
        'This may cause unintended side effects on production data.',
      );
    }

    // Log current configuration in debug
    debugPrint('[AppConfig] Environment: ${env.name}');
    debugPrint('[AppConfig] API URL: $activeApiUrl');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API Endpoints
  // ─────────────────────────────────────────────────────────────────────────

  /// API version prefix for all endpoints.
  static const String apiVersion = '/api/v1';

  /// Full API URL with version prefix.
  static String get apiUrl => '$activeApiUrl$apiVersion';

  // ─────────────────────────────────────────────────────────────────────────
  // Timeout Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Connection timeout duration for API requests.
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// Receive timeout duration for API responses.
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ─────────────────────────────────────────────────────────────────────────
  // App Metadata
  // ─────────────────────────────────────────────────────────────────────────

  /// Application name.
  static const String appName = 'WorkOn';

  /// Application version.
  static const String appVersion = '1.0.0';

  // ─────────────────────────────────────────────────────────────────────────
  // Google Maps Configuration (PR-F07)
  // ─────────────────────────────────────────────────────────────────────────

  /// Google Maps API key from environment variable.
  /// Set via: --dart-define=GOOGLE_MAPS_API_KEY=your_key
  /// Fallback for development only.
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '', // Must be set via build args in production
  );

  /// Check if Google Maps is configured.
  static bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;

  /// Default map center (Montreal).
  static const double defaultMapLat = 45.5017;
  static const double defaultMapLng = -73.5673;
  static const double defaultMapZoom = 12.0;

  // ─────────────────────────────────────────────────────────────────────────
  // Stripe Configuration (PR-5)
  // ─────────────────────────────────────────────────────────────────────────

  /// Stripe publishable key from environment variable.
  /// Set via: --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
  /// For testing, use Stripe test mode publishable key.
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_51RAxXTJ6SQZnNrKAhGZAMFDhT8u8BFUVx6u4bJQ9N3nM8L7KVMHQ5jX8mWnY4u9cC3zK2LBvNxS8RrT1yPqA0vJw00a1bCdEfG', // Test key - replace in production
  );

  /// Check if Stripe is configured.
  static bool get hasStripeKey => stripePublishableKey.isNotEmpty;

  /// Merchant display name for Stripe Payment Sheet.
  static const String stripeMerchantName = 'WorkOn';

  // ─────────────────────────────────────────────────────────────────────────
  // PR-H1: Feature Flags / Kill-Switch
  // ─────────────────────────────────────────────────────────────────────────

  /// Maintenance mode flag. When true, app shows MaintenanceScreen.
  /// Set via: --dart-define=MAINTENANCE_MODE=true
  /// Default: false (app runs normally)
  static const bool _maintenanceModeEnv = bool.fromEnvironment(
    'MAINTENANCE_MODE',
    defaultValue: false,
  );

  /// Runtime override for maintenance mode (allows toggling without rebuild).
  static bool _maintenanceModeOverride = false;

  /// Returns true if maintenance mode is active.
  static bool get maintenanceMode => _maintenanceModeEnv || _maintenanceModeOverride;

  /// Sets maintenance mode at runtime (for remote config later).
  static void setMaintenanceMode(bool value) {
    _maintenanceModeOverride = value;
  }

  /// Auth disabled flag. When true, login/register are blocked.
  /// Set via: --dart-define=DISABLE_AUTH=true
  /// Default: false (auth works normally)
  static const bool _disableAuthEnv = bool.fromEnvironment(
    'DISABLE_AUTH',
    defaultValue: false,
  );

  static bool _disableAuthOverride = false;

  /// Returns true if auth is disabled.
  static bool get disableAuth => _disableAuthEnv || _disableAuthOverride;

  /// Sets auth disabled at runtime.
  static void setDisableAuth(bool value) {
    _disableAuthOverride = value;
  }

  /// Payments disabled flag. When true, payment entry points are blocked.
  /// Set via: --dart-define=DISABLE_PAYMENTS=true
  /// Default: false (payments work normally)
  static const bool _disablePaymentsEnv = bool.fromEnvironment(
    'DISABLE_PAYMENTS',
    defaultValue: false,
  );

  static bool _disablePaymentsOverride = false;

  /// Returns true if payments are disabled.
  static bool get disablePayments => _disablePaymentsEnv || _disablePaymentsOverride;

  /// Sets payments disabled at runtime.
  static void setDisablePayments(bool value) {
    _disablePaymentsOverride = value;
  }

  /// Notifier for kill-switch state changes (allows UI to react).
  static final ValueNotifier<int> killSwitchNotifier = ValueNotifier(0);

  /// Triggers UI refresh for kill-switch state changes.
  static void notifyKillSwitchChanged() {
    killSwitchNotifier.value++;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-G2: Environment Badge Widget
// PR-H1: Extended with Maintenance Mode Gate
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps a child widget with an environment badge overlay and kill-switch gates.
///
/// Shows a small "DEV" or "STAGING" badge in the top-left corner
/// for non-production environments. In production, no badge is shown.
///
/// **PR-H1:** Also handles maintenance mode gate (highest priority).
/// When [AppConfig.maintenanceMode] is true, shows [MaintenanceScreen].
///
/// Usage:
/// ```dart
/// runApp(EnvBadge(child: MyApp()));
/// ```
class EnvBadge extends StatelessWidget {
  const EnvBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppConfig.killSwitchNotifier,
      builder: (context, _, __) {
        // PR-H1: Maintenance mode gate (highest priority)
        if (AppConfig.maintenanceMode) {
          return const MaintenanceScreen();
        }

        // No badge in production
        if (AppConfig.isProd) {
          return child;
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              child,
              // Badge overlay
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, top: 4),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConfig.env.badgeColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        AppConfig.env.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-H1: Maintenance Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen maintenance mode UI.
///
/// Displayed when [AppConfig.maintenanceMode] is true.
/// Shows a friendly French message with a retry button.
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Maintenance icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build_rounded,
                      size: 64,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Maintenance en cours',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'Nous améliorons l\'application pour vous offrir '
                    'une meilleure expérience. Veuillez réessayer dans '
                    'quelques minutes.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Retry button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Re-evaluate kill-switch flags (triggers rebuild)
                        AppConfig.notifyKillSwitchChanged();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-H1: KillSwitch Helper
// ─────────────────────────────────────────────────────────────────────────────

/// Helper class for checking kill-switch states and displaying messages.
///
/// Usage:
/// ```dart
/// void onLoginPressed() {
///   if (KillSwitch.isAuthBlocked) {
///     KillSwitch.showAuthDisabledMessage(context);
///     return;
///   }
///   // Proceed with login...
/// }
/// ```
abstract final class KillSwitch {
  /// Returns true if app is in maintenance mode.
  static bool get isMaintenance => AppConfig.maintenanceMode;

  /// Returns true if auth actions should be blocked.
  static bool get isAuthBlocked => AppConfig.disableAuth;

  /// Returns true if payment actions should be blocked.
  static bool get isPaymentsBlocked => AppConfig.disablePayments;

  /// Shows a snackbar when auth is disabled.
  static void showAuthDisabledMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('L\'authentification est temporairement désactivée.'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows a snackbar when payments are disabled.
  static void showPaymentsDisabledMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Les paiements sont temporairement désactivés.'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

