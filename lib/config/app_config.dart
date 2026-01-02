/// Centralized application configuration for WorkOn.
///
/// This file contains all environment-specific settings including
/// backend API URLs for Railway deployment.
///
/// **PR-G2:** Added AppEnv enum, safety guards, and environment badge.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/remote_config/remote_config.dart';

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

  /// PR-12: Returns true if API configuration is invalid.
  /// Checks for empty or malformed API URL.
  static bool get isMisconfigured {
    final url = activeApiUrl;
    if (url.isEmpty) {
      debugPrint('[AppConfig] ❌ MISCONFIGURED: API URL is empty');
      return true;
    }
    // Basic URL validation
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      debugPrint('[AppConfig] ❌ MISCONFIGURED: Invalid API URL: $url');
      return true;
    }
    return false;
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
    // PR-12: Log misconfiguration status (always, for diagnostics)
    if (isMisconfigured) {
      debugPrint('[AppConfig] ❌ CRITICAL: App is misconfigured - blocking UI');
    }

    // Only enforce strict checks in debug/profile mode
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
  /// Checks: remote config → runtime override → compile-time env.
  static bool get maintenanceMode {
    // PR-H3: Remote config takes precedence if set
    final remote = RemoteConfig.current?.maintenanceMode;
    if (remote != null) return remote;
    return _maintenanceModeEnv || _maintenanceModeOverride;
  }

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
  /// Checks: remote config → runtime override → compile-time env.
  static bool get disableAuth {
    final remote = RemoteConfig.current?.disableAuth;
    if (remote != null) return remote;
    return _disableAuthEnv || _disableAuthOverride;
  }

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
  /// Checks: remote config → runtime override → compile-time env.
  static bool get disablePayments {
    final remote = RemoteConfig.current?.disablePayments;
    if (remote != null) return remote;
    return _disablePaymentsEnv || _disablePaymentsOverride;
  }

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
  // PR-H2: Forced Update / Minimum App Version
  // ─────────────────────────────────────────────────────────────────────────

  /// Current app version (semantic versioning).
  /// Set via: --dart-define=APP_VERSION=1.2.3
  static const String appVersionH2 = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// Minimum required app version.
  /// Set via: --dart-define=MIN_APP_VERSION=1.0.0
  static const String minAppVersion = String.fromEnvironment(
    'MIN_APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// iOS App Store URL for forced update.
  /// Set via: --dart-define=STORE_URL_IOS=https://apps.apple.com/app/id...
  static const String storeUrlIos = String.fromEnvironment(
    'STORE_URL_IOS',
    defaultValue: 'https://apps.apple.com/app/workon',
  );

  /// Android Play Store URL for forced update.
  /// Set via: --dart-define=STORE_URL_ANDROID=https://play.google.com/store/apps/details?id=...
  static const String storeUrlAndroid = String.fromEnvironment(
    'STORE_URL_ANDROID',
    defaultValue: 'https://play.google.com/store/apps/details?id=com.workon.app',
  );

  /// Effective minimum app version (remote config → compile-time).
  static String get effectiveMinAppVersion {
    final remote = RemoteConfig.current?.minAppVersion;
    if (remote != null && remote.isNotEmpty) return remote;
    return minAppVersion;
  }

  /// Effective iOS store URL (remote config → compile-time).
  static String get effectiveStoreUrlIos {
    final remote = RemoteConfig.current?.storeUrlIos;
    if (remote != null && remote.isNotEmpty) return remote;
    return storeUrlIos;
  }

  /// Effective Android store URL (remote config → compile-time).
  static String get effectiveStoreUrlAndroid {
    final remote = RemoteConfig.current?.storeUrlAndroid;
    if (remote != null && remote.isNotEmpty) return remote;
    return storeUrlAndroid;
  }

  /// Returns true if app version is below minimum required version.
  /// Fail-open in release mode (returns false on parse error).
  static bool get isUpdateRequired {
    try {
      final current = VersionUtils.parse(appVersionH2);
      final minimum = VersionUtils.parse(effectiveMinAppVersion);
      return VersionUtils.compare(current, minimum) < 0;
    } catch (e) {
      // Fail-open: don't block app if version parsing fails
      if (kDebugMode) {
        debugPrint('[AppConfig] ⚠️ Version parse error: $e');
      }
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PR-H3: Remote Config Integration
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes remote config (fetches in background, non-blocking).
  /// Safe to call multiple times (deduped internally).
  static Future<void> initRemoteConfig() async {
    if (!RemoteConfig.isEnabled) return;
    try {
      await RemoteConfig.get();
      // Notify UI to re-evaluate gates after fetch
      notifyKillSwitchChanged();
    } catch (_) {
      // Fail-open: ignore errors
    }
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
        // PR-12: Misconfiguration gate (highest priority - prevents crashes)
        if (AppConfig.isMisconfigured) {
          return const MisconfigurationScreen();
        }

        // PR-H2: Forced update gate
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
// PR-12: Misconfiguration Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen misconfiguration UI.
///
/// Displayed when [AppConfig.isMisconfigured] is true.
/// Shows a friendly French message explaining the app is misconfigured.
/// This prevents crashes when API URL is missing or invalid.
class MisconfigurationScreen extends StatelessWidget {
  const MisconfigurationScreen({super.key});

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
                  // Error icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_alert_outlined,
                      size: 64,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Configuration manquante',
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
                    'L\'application n\'est pas correctement configurée. '
                    'Veuillez contacter le support technique ou '
                    'réinstaller l\'application.',
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
                        // Re-evaluate (triggers rebuild)
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

// ─────────────────────────────────────────────────────────────────────────────
// PR-H2: Version Utilities
// ─────────────────────────────────────────────────────────────────────────────

/// Parsed semantic version (major.minor.patch).
class Version {
  const Version(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  @override
  String toString() => '$major.$minor.$patch';
}

/// Utilities for semantic version parsing and comparison.
abstract final class VersionUtils {
  /// Parses a version string (e.g., "1.2.3") into a [Version] object.
  /// Throws [FormatException] if the format is invalid.
  static Version parse(String versionString) {
    final parts = versionString.trim().split('.');
    if (parts.isEmpty || parts.length > 3) {
      throw FormatException('Invalid version format: $versionString');
    }

    int parseComponent(String s) {
      final value = int.tryParse(s);
      if (value == null || value < 0) {
        throw FormatException('Invalid version component: $s');
      }
      return value;
    }

    final major = parseComponent(parts[0]);
    final minor = parts.length > 1 ? parseComponent(parts[1]) : 0;
    final patch = parts.length > 2 ? parseComponent(parts[2]) : 0;

    return Version(major, minor, patch);
  }

  /// Compares two versions.
  /// Returns negative if [a] < [b], zero if equal, positive if [a] > [b].
  static int compare(Version a, Version b) {
    if (a.major != b.major) return a.major.compareTo(b.major);
    if (a.minor != b.minor) return a.minor.compareTo(b.minor);
    return a.patch.compareTo(b.patch);
  }

  /// Opens the appropriate store URL based on platform.
  /// Uses effective URLs (remote config → compile-time).
  static Future<void> openStore() async {
    final String url;
    try {
      url = Platform.isIOS
          ? AppConfig.effectiveStoreUrlIos
          : AppConfig.effectiveStoreUrlAndroid;
    } catch (_) {
      // Platform not available (web), use Android URL
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PR-H2: Forced Update Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen forced update UI.
///
/// Displayed when [AppConfig.isUpdateRequired] is true.
/// Shows a French message with a button to open the store.
class ForcedUpdateScreen extends StatelessWidget {
  const ForcedUpdateScreen({super.key});

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
                  // Update icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      size: 64,
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
                      color: Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'Une nouvelle version de WorkOn est disponible. '
                    'Veuillez mettre à jour l\'application pour continuer.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Update button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => VersionUtils.openStore(),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Mettre à jour'),
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
                  // "Plus tard" button - ONLY for dev/staging, NEVER in production
                  if (!AppConfig.isProd && !kReleaseMode) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Skip update check (for testing only)
                        AppConfig.notifyKillSwitchChanged();
                      },
                      child: const Text(
                        'Plus tard (dev uniquement)',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  // Version info (debug only)
                  if (kDebugMode) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Version: ${AppConfig.appVersionH2}\n'
                      'Minimum: ${AppConfig.minAppVersion}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                      textAlign: TextAlign.center,
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

