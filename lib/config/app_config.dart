/// Centralized application configuration for WorkOn.
///
/// This file contains all environment-specific settings including
/// backend API URLs for Railway deployment.
///
/// **PR-G2:** Added AppEnv enum, safety guards, and environment badge.
/// **PR-H2:** Added forced update gate with version comparison.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // ─────────────────────────────────────────────────────────────────────────
  // PR-H2: Forced Update / Version Gate
  // ─────────────────────────────────────────────────────────────────────────

  /// Current app version from compile-time define.
  /// Set via: --dart-define=APP_VERSION=1.2.3
  /// Default: "1.0.0"
  static const String currentAppVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// Minimum required app version from compile-time define.
  /// Set via: --dart-define=MIN_APP_VERSION=1.0.0
  /// Default: "1.0.0" (no blocking by default)
  static const String minAppVersion = String.fromEnvironment(
    'MIN_APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// iOS App Store URL.
  /// Set via: --dart-define=STORE_URL_IOS=https://apps.apple.com/...
  static const String storeUrlIos = String.fromEnvironment(
    'STORE_URL_IOS',
    defaultValue: 'https://apps.apple.com/app/workon/id123456789',
  );

  /// Android Play Store URL.
  /// Set via: --dart-define=STORE_URL_ANDROID=https://play.google.com/...
  static const String storeUrlAndroid = String.fromEnvironment(
    'STORE_URL_ANDROID',
    defaultValue: 'https://play.google.com/store/apps/details?id=com.workon.app',
  );

  /// Returns the appropriate store URL for the current platform.
  static String get storeUrl {
    // Use defaultTargetPlatform which is available without context
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return storeUrlIos;
      case TargetPlatform.android:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return storeUrlAndroid;
    }
  }

  /// Returns true if app version is below minimum required version.
  ///
  /// Fail-open in release mode: if version parsing fails, returns false (not blocked).
  static bool get isUpdateRequired {
    try {
      final comparison = VersionUtils.compare(currentAppVersion, minAppVersion);
      return comparison < 0; // current < min = update required
    } catch (e) {
      // Fail-open: if parsing fails, don't block
      if (!kReleaseMode) {
        debugPrint('[AppConfig] Version parse error: $e');
      }
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-H2: Version Utilities
// ─────────────────────────────────────────────────────────────────────────────

/// Simple semantic version comparison utilities.
///
/// Supports only numeric major.minor.patch format.
/// Strips anything after '-' or '+' (pre-release/build metadata).
abstract final class VersionUtils {
  /// Compares two version strings.
  ///
  /// Returns:
  /// - negative if a < b
  /// - zero if a == b
  /// - positive if a > b
  ///
  /// Throws [FormatException] if version format is invalid.
  static int compare(String a, String b) {
    final partsA = _parse(a);
    final partsB = _parse(b);

    for (int i = 0; i < 3; i++) {
      final diff = partsA[i] - partsB[i];
      if (diff != 0) return diff;
    }
    return 0;
  }

  /// Parses version string into [major, minor, patch] list.
  static List<int> _parse(String version) {
    // Strip pre-release/build metadata (everything after - or +)
    var clean = version.split('-').first.split('+').first.trim();

    // Split by dot
    final parts = clean.split('.');
    if (parts.isEmpty || parts.length > 3) {
      throw FormatException('Invalid version format: $version');
    }

    final result = <int>[0, 0, 0];
    for (int i = 0; i < parts.length && i < 3; i++) {
      final parsed = int.tryParse(parts[i]);
      if (parsed == null || parsed < 0) {
        throw FormatException('Invalid version number: ${parts[i]} in $version');
      }
      result[i] = parsed;
    }
    return result;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-G2: Environment Badge Widget
// PR-H1: Extended with maintenance mode gate
// PR-H2: Extended with forced update gate
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps a child widget with environment badge, maintenance mode, and update gate.
///
/// Gate priority (checked in order):
/// 1. [AppConfig.isUpdateRequired] → [ForcedUpdateScreen]
/// 2. [AppConfig.maintenanceMode] → [MaintenanceScreen]
/// 3. Normal app flow
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
    // PR-H1: Listen to kill-switch changes for reactive updates
    return ValueListenableBuilder<int>(
      valueListenable: AppConfig.killSwitchNotifier,
      builder: (context, _, __) {
        // PR-H2: Forced update gate (highest priority)
        if (AppConfig.isUpdateRequired) {
          return const ForcedUpdateScreen();
        }

        // PR-H1: Maintenance mode gate
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

/// Full-screen maintenance mode display.
///
/// Shows a friendly message in French with a retry button.
/// Retry re-checks the in-memory config and triggers a rebuild.
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.build_rounded,
                      size: 48,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Maintenance en cours',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Nous améliorons WorkOn pour toi.\nL\'application sera disponible très bientôt.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      decoration: TextDecoration.none,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Retry button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Re-check config and trigger rebuild
                      AppConfig.notifyKillSwitchChanged();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
// PR-H2: Forced Update Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen forced update display.
///
/// Shows a friendly message in French with a button to open the store.
/// In non-production, a "Skip" button is available for testing.
class ForcedUpdateScreen extends StatelessWidget {
  const ForcedUpdateScreen({super.key});

  Future<void> _openStore(BuildContext context) async {
    final url = Uri.parse(AppConfig.storeUrl);
    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le store. Mets à jour manuellement.'),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le store. Mets à jour manuellement.'),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      size: 48,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Mise à jour requise',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Une nouvelle version de WorkOn est disponible.\nMets à jour pour continuer à utiliser l\'application.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      decoration: TextDecoration.none,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Version info (debug only)
                  if (!kReleaseMode)
                    Text(
                      'v${AppConfig.currentAppVersion} → v${AppConfig.minAppVersion}+',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Update button
                  Builder(
                    builder: (context) => ElevatedButton.icon(
                      onPressed: () => _openStore(context),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Mettre à jour'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Skip button (non-prod only, for testing)
                  if (!AppConfig.isProd) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Force skip by triggering a rebuild
                        // In real usage, this would be gated by remote config
                        AppConfig.notifyKillSwitchChanged();
                      },
                      child: const Text(
                        'Plus tard (dev only)',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
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
// PR-H1: Kill-Switch Helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Helper to check if auth actions should be blocked.
///
/// Use at login/register entry points:
/// ```dart
/// if (KillSwitch.isAuthBlocked) {
///   KillSwitch.showAuthDisabledMessage(context);
///   return;
/// }
/// ```
abstract final class KillSwitch {
  /// Returns true if auth is blocked.
  static bool get isAuthBlocked => AppConfig.disableAuth;

  /// Returns true if payments are blocked.
  static bool get isPaymentsBlocked => AppConfig.disablePayments;

  /// Shows a snackbar message when auth is disabled.
  static void showAuthDisabledMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion temporairement indisponible. Réessaie plus tard.'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows a snackbar message when payments are disabled.
  static void showPaymentsDisabledMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paiements temporairement indisponibles. Réessaie plus tard.'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}


