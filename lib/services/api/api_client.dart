/// Minimal API client for WorkOn backend integration.
///
/// This client provides a centralized HTTP layer configured with
/// [AppConfig] settings. No endpoints or business logic included.
///
/// Usage:
/// ```dart
/// final response = await ApiClient.get('/endpoint');
/// ```
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

/// Centralized API client for backend communication.
///
/// Configured with:
/// - Base URL from [AppConfig.activeApiUrl]
/// - Timeout settings from [AppConfig]
/// - Prepared headers structure (auth to be added later)
abstract final class ApiClient {
  // ─────────────────────────────────────────────────────────────────────────
  // HTTP Client Instance
  // ─────────────────────────────────────────────────────────────────────────

  /// Internal HTTP client instance.
  static final http.Client _client = http.Client();

  /// Exposes the underlying HTTP client for advanced usage.
  static http.Client get client => _client;

  // ─────────────────────────────────────────────────────────────────────────
  // Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Base URL for all API requests.
  static String get baseUrl => AppConfig.activeApiUrl;

  /// Connection timeout duration.
  static Duration get connectionTimeout => AppConfig.connectionTimeout;

  /// Receive timeout duration.
  static Duration get receiveTimeout => AppConfig.receiveTimeout;

  // ─────────────────────────────────────────────────────────────────────────
  // Headers
  // ─────────────────────────────────────────────────────────────────────────

  /// Default headers for all requests.
  ///
  /// Auth headers will be injected here in future PRs.
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // TODO(PR#future): Add Authorization header from auth service
        // 'Authorization': 'Bearer ${AuthService.token}',
      };

  // ─────────────────────────────────────────────────────────────────────────
  // URL Builder
  // ─────────────────────────────────────────────────────────────────────────

  /// Builds a full URI from an endpoint path.
  ///
  /// Example: `buildUri('/users')` → `https://workon-backend.../api/v1/users`
  static Uri buildUri(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('${AppConfig.apiUrl}$path');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  /// Closes the HTTP client.
  ///
  /// Call this when the app is disposing to free resources.
  static void dispose() {
    _client.close();
  }
}

