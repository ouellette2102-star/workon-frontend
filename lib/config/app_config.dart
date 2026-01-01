/// Centralized application configuration for WorkOn.
///
/// This file contains all environment-specific settings including
/// backend API URLs for Railway deployment.
library;

/// Application configuration class providing centralized access
/// to all environment-specific settings.
abstract final class AppConfig {
  // ─────────────────────────────────────────────────────────────────────────
  // Backend API Configuration (Railway)
  // ─────────────────────────────────────────────────────────────────────────

  /// Production backend API base URL hosted on Railway.
  static const String apiBaseUrl =
      'https://workon-backend-production.up.railway.app';

  /// Development/staging backend API base URL.
  /// NOTE: Points to production until a separate dev backend is deployed.
  static const String apiBaseUrlDev =
      'https://workon-backend-production.up.railway.app';

  /// Current active API URL based on environment.
  static const String activeApiUrl = _isProduction ? apiBaseUrl : apiBaseUrlDev;

  // ─────────────────────────────────────────────────────────────────────────
  // Environment Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Flag indicating whether the app is running in production mode.
  /// Set to `true` for release builds.
  static const bool _isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  /// Returns `true` if running in production environment.
  static bool get isProduction => _isProduction;

  /// Returns `true` if running in development environment.
  static bool get isDevelopment => !_isProduction;

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
}

