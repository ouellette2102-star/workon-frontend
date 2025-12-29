/// Offers API client for WorkOn.
///
/// Thin API layer for `/api/v1/offers` endpoints.
/// Uses existing [ApiClient] for HTTP requests.
///
/// **PR-F15:** Initial implementation for mission applications.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../auth/auth_errors.dart';
import '../auth/auth_service.dart';

/// Exception thrown by [OffersApi].
class OffersApiException implements Exception {
  final String message;
  final int? statusCode;

  const OffersApiException([this.message = 'Offers API error', this.statusCode]);

  @override
  String toString() => 'OffersApiException: $message';
}

/// Exception thrown when user has already applied to a mission.
class AlreadyAppliedException extends OffersApiException {
  const AlreadyAppliedException()
      : super('Vous avez déjà postulé à cette mission.', 409);
}

/// API client for offers endpoints.
///
/// All methods require authentication (Bearer token).
///
/// ## Usage
///
/// ```dart
/// final api = OffersApi();
/// await api.createOffer(missionId: 'mission-123');
/// ```
class OffersApi {
  /// Creates an offer (application) for a mission.
  ///
  /// Calls `POST /api/v1/offers`.
  ///
  /// Parameters:
  /// - [missionId]: ID of the mission to apply to
  /// - [message]: Optional application message (cover letter)
  ///
  /// Throws:
  /// - [UnauthorizedException] if not authenticated
  /// - [AlreadyAppliedException] if user already applied (409)
  /// - [OffersApiException] on other errors
  Future<void> createOffer({
    required String missionId,
    String? message,
  }) async {
    debugPrint('[OffersApi] Creating offer for mission: $missionId');

    // Check auth
    if (!AuthService.hasSession) {
      debugPrint('[OffersApi] No active session');
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[OffersApi] No token available');
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/offers');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    final body = <String, dynamic>{
      'missionId': missionId,
    };
    if (message != null && message.trim().isNotEmpty) {
      body['message'] = message.trim();
    }

    try {
      debugPrint('[OffersApi] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[OffersApi] Response status: ${response.statusCode}');

      switch (response.statusCode) {
        case 200:
        case 201:
          debugPrint('[OffersApi] Offer created successfully');
          return;

        case 400:
          final msg = _extractErrorMessage(response.body);
          // Check if it's an "already applied" error in the message
          if (msg != null && msg.toLowerCase().contains('already')) {
            throw const AlreadyAppliedException();
          }
          throw OffersApiException(msg ?? 'Requête invalide', 400);

        case 401:
        case 403:
          debugPrint('[OffersApi] Unauthorized');
          throw const UnauthorizedException();

        case 404:
          throw const OffersApiException('Mission non trouvée', 404);

        case 409:
          // Conflict = already applied
          debugPrint('[OffersApi] Already applied (409)');
          throw const AlreadyAppliedException();

        case 422:
          final msg = _extractErrorMessage(response.body);
          throw OffersApiException(msg ?? 'Données invalides', 422);

        case 429:
          throw const OffersApiException('Trop de requêtes. Réessaie plus tard.', 429);

        default:
          if (response.statusCode >= 500) {
            throw const OffersApiException('Erreur serveur', 500);
          }
          throw OffersApiException('Erreur ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('[OffersApi] Request timeout');
      throw const OffersApiException('Connexion impossible. Vérifiez votre réseau.');
    } on http.ClientException catch (e) {
      debugPrint('[OffersApi] Client error: $e');
      throw const OffersApiException('Erreur réseau. Vérifiez votre connexion.');
    } on Exception catch (e) {
      if (e is OffersApiException || e is AuthException) rethrow;
      debugPrint('[OffersApi] Unexpected error: $e');
      throw const OffersApiException('Une erreur est survenue.');
    }
  }

  /// Fetches offers created by the current user.
  ///
  /// Calls `GET /api/v1/offers/mine` or similar.
  ///
  /// Returns a list of mission IDs that the user has applied to.
  ///
  /// Throws:
  /// - [UnauthorizedException] if not authenticated
  /// - [OffersApiException] on other errors
  Future<List<String>> fetchMyOffers() async {
    debugPrint('[OffersApi] Fetching my offers...');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/offers/mine');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[OffersApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[OffersApi] fetchMyOffers response: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        // If endpoint doesn't exist (404), return empty list
        if (response.statusCode == 404) {
          debugPrint('[OffersApi] /offers/mine not found, returning empty list');
          return [];
        }
        throw OffersApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body);
      
      // Handle various response formats
      List<dynamic> items;
      if (json is List) {
        items = json;
      } else if (json is Map<String, dynamic>) {
        items = json['data'] ?? json['offers'] ?? [];
      } else {
        items = [];
      }

      // Extract mission IDs
      final missionIds = <String>[];
      for (final item in items) {
        if (item is Map<String, dynamic>) {
          final missionId = item['missionId'] ?? item['mission_id'] ?? 
              (item['mission'] is Map ? item['mission']['id'] : null);
          if (missionId != null) {
            missionIds.add(missionId.toString());
          }
        }
      }

      debugPrint('[OffersApi] Found ${missionIds.length} applied missions');
      return missionIds;
    } on TimeoutException {
      throw const OffersApiException('Connexion timeout');
    } on http.ClientException {
      throw const OffersApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is OffersApiException || e is AuthException) rethrow;
      debugPrint('[OffersApi] fetchMyOffers unexpected error: $e');
      return []; // Graceful fallback
    }
  }

  /// Extracts error message from response body.
  String? _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String? ??
          json['error'] as String? ??
          json['errors']?.toString();
    } catch (_) {
      return null;
    }
  }
}

