/// Missions API client for WorkOn.
///
/// Thin API layer for `/api/v1/missions-local` endpoints.
/// Uses existing [ApiClient] for HTTP requests.
///
/// **PR-F05:** Initial implementation for missions feed.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../auth/auth_service.dart';
import '../auth/auth_errors.dart';
import 'mission_models.dart';

/// Exception thrown by [MissionsApi].
class MissionsApiException implements Exception {
  final String message;
  const MissionsApiException([this.message = 'Missions API error']);

  @override
  String toString() => 'MissionsApiException: $message';
}

/// API client for missions endpoints.
///
/// All methods require authentication (Bearer token).
///
/// ## Usage
///
/// ```dart
/// final api = MissionsApi();
/// final missions = await api.fetchNearby(
///   latitude: 45.5017,
///   longitude: -73.5673,
///   radiusKm: 10,
/// );
/// ```
class MissionsApi {
  /// Fetches nearby missions.
  ///
  /// Calls `GET /api/v1/missions-local/nearby`.
  ///
  /// Parameters:
  /// - [latitude]: User's latitude
  /// - [longitude]: User's longitude
  /// - [radiusKm]: Search radius in kilometers (default: 10)
  ///
  /// Returns a list of [Mission] sorted by distance.
  ///
  /// Throws:
  /// - [UnauthorizedException] if not authenticated
  /// - [MissionsApiException] on other errors
  Future<List<Mission>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    debugPrint('[MissionsApi] Fetching nearby missions...');

    // Check auth
    if (!AuthService.hasSession) {
      debugPrint('[MissionsApi] No active session');
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[MissionsApi] No token available');
      throw const UnauthorizedException();
    }

    // Build URI with query params
    final uri = Uri.parse('${ApiClient.baseUrl}/api/v1/missions-local/nearby')
        .replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radiusKm': radiusKm.toString(),
    });

    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionsApi] Response status: ${response.statusCode}');

      return _handleListResponse(response);
    } on TimeoutException {
      debugPrint('[MissionsApi] Request timeout');
      throw const MissionsApiException('Connexion timeout');
    } on http.ClientException catch (e) {
      debugPrint('[MissionsApi] Client error: $e');
      throw const MissionsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionsApiException || e is AuthException) rethrow;
      debugPrint('[MissionsApi] Unexpected error: $e');
      throw const MissionsApiException();
    }
  }

  /// Fetches mission details by ID.
  ///
  /// Calls `GET /api/v1/missions-local/:id`.
  ///
  /// **PR-F06:** Enhanced logging and error handling.
  ///
  /// Throws:
  /// - [UnauthorizedException] if not authenticated
  /// - [MissionsApiException] if mission not found or other error
  Future<Mission> fetchById(String id) async {
    debugPrint('[MissionsApi] fetchById: $id');

    // Validate ID
    if (id.isEmpty) {
      debugPrint('[MissionsApi] fetchById: empty ID provided');
      throw const MissionsApiException('ID de mission invalide');
    }

    // Check auth
    if (!AuthService.hasSession) {
      debugPrint('[MissionsApi] fetchById: no active session');
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[MissionsApi] fetchById: no token available');
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions-local/$id');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionsApi] fetchById response: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('[MissionsApi] fetchById: unauthorized');
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        debugPrint('[MissionsApi] fetchById: mission not found');
        throw const MissionsApiException('Mission non trouvée');
      }

      if (response.statusCode >= 500) {
        debugPrint('[MissionsApi] fetchById: server error');
        throw const MissionsApiException('Erreur serveur. Réessayez plus tard.');
      }

      if (response.statusCode != 200) {
        debugPrint('[MissionsApi] fetchById: unexpected status ${response.statusCode}');
        throw MissionsApiException('Erreur inattendue (${response.statusCode})');
      }

      final json = jsonDecode(response.body);
      final data = json is Map<String, dynamic>
          ? (json['data'] ?? json)
          : json;

      final mission = Mission.fromJson(data as Map<String, dynamic>);
      debugPrint('[MissionsApi] fetchById: success - ${mission.title}');
      return mission;
    } on TimeoutException {
      debugPrint('[MissionsApi] fetchById: timeout');
      throw const MissionsApiException('Délai de connexion dépassé');
    } on http.ClientException catch (e) {
      debugPrint('[MissionsApi] fetchById: network error - $e');
      throw const MissionsApiException('Erreur réseau. Vérifiez votre connexion.');
    } on FormatException catch (e) {
      debugPrint('[MissionsApi] fetchById: JSON parse error - $e');
      throw const MissionsApiException('Réponse invalide du serveur');
    } on Exception catch (e) {
      if (e is MissionsApiException || e is AuthException) rethrow;
      debugPrint('[MissionsApi] fetchById: unexpected error - $e');
      throw const MissionsApiException('Erreur inattendue');
    }
  }

  /// Fetches user's created missions.
  ///
  /// Calls `GET /api/v1/missions-local/my-missions`.
  Future<List<Mission>> fetchMyMissions() async {
    debugPrint('[MissionsApi] Fetching my missions...');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions-local/my-missions');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      return _handleListResponse(response);
    } on TimeoutException {
      throw const MissionsApiException('Connexion timeout');
    } on http.ClientException {
      throw const MissionsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionsApiException || e is AuthException) rethrow;
      throw const MissionsApiException();
    }
  }

  /// Fetches user's assigned missions.
  ///
  /// Calls `GET /api/v1/missions-local/my-assignments`.
  Future<List<Mission>> fetchMyAssignments() async {
    debugPrint('[MissionsApi] Fetching my assignments...');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions-local/my-assignments');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      return _handleListResponse(response);
    } on TimeoutException {
      throw const MissionsApiException('Connexion timeout');
    } on http.ClientException {
      throw const MissionsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionsApiException || e is AuthException) rethrow;
      throw const MissionsApiException();
    }
  }

  /// Handles list response parsing.
  List<Mission> _handleListResponse(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const UnauthorizedException();
    }

    if (response.statusCode >= 500) {
      throw const MissionsApiException('Erreur serveur');
    }

    if (response.statusCode != 200) {
      throw MissionsApiException('Erreur ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    // Handle both array and wrapped responses
    List<dynamic> items;
    if (json is List) {
      items = json;
    } else if (json is Map<String, dynamic>) {
      items = json['data'] ?? json['missions'] ?? [];
    } else {
      items = [];
    }

    debugPrint('[MissionsApi] Parsed ${items.length} missions');

    return items
        .map((item) => Mission.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

