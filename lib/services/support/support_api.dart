/// Support API client for WorkOn.
///
/// Handles customer support ticket CRUD operations.
///
/// **FL-SUPPORT:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../auth/auth_errors.dart';
import '../auth/token_storage.dart';
import 'support_models.dart';

/// Exception thrown by [SupportApi].
class SupportApiException implements Exception {
  final String message;
  final int? statusCode;

  const SupportApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'SupportApiException: $message';
}

/// API client for support ticket operations.
class SupportApi {
  const SupportApi();

  /// Creates a new support ticket.
  ///
  /// Calls `POST /api/v1/support/tickets`.
  Future<SupportTicket> createTicket(CreateTicketDto dto) async {
    debugPrint('[SupportApi] Creating ticket: ${dto.subject}');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/support/tickets');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[SupportApi] POST $uri');
      final response = await ApiClient.client
          .post(uri, headers: headers, body: jsonEncode(dto.toJson()))
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[SupportApi] createTicket: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 400) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw SupportApiException(
          json['message'] as String? ?? 'Données invalides',
          400,
        );
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw SupportApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['ticket'] ?? json['data'] ?? json;
      return SupportTicket.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const SupportApiException('Connexion impossible');
    } on http.ClientException {
      throw const SupportApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is SupportApiException || e is AuthException) rethrow;
      debugPrint('[SupportApi] createTicket error: $e');
      throw const SupportApiException('Une erreur est survenue');
    }
  }

  /// Gets all tickets for the current user.
  ///
  /// Calls `GET /api/v1/support/tickets`.
  Future<TicketListResponse> getTickets({int page = 1, int limit = 20}) async {
    debugPrint('[SupportApi] Getting tickets (page: $page, limit: $limit)');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final baseUri = ApiClient.buildUri('/support/tickets');
    final uri = baseUri.replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[SupportApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[SupportApi] getTickets: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw SupportApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TicketListResponse.fromJson(json);
    } on TimeoutException {
      throw const SupportApiException('Connexion impossible');
    } on http.ClientException {
      throw const SupportApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is SupportApiException || e is AuthException) rethrow;
      debugPrint('[SupportApi] getTickets error: $e');
      throw const SupportApiException('Une erreur est survenue');
    }
  }

  /// Gets a specific ticket by ID with all messages.
  ///
  /// Calls `GET /api/v1/support/tickets/:id`.
  Future<SupportTicket> getTicket(String ticketId) async {
    debugPrint('[SupportApi] Getting ticket: $ticketId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/support/tickets/$ticketId');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[SupportApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[SupportApi] getTicket: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        throw const SupportApiException('Ticket introuvable', 404);
      }

      if (response.statusCode != 200) {
        throw SupportApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['ticket'] ?? json['data'] ?? json;
      return SupportTicket.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const SupportApiException('Connexion impossible');
    } on http.ClientException {
      throw const SupportApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is SupportApiException || e is AuthException) rethrow;
      debugPrint('[SupportApi] getTicket error: $e');
      throw const SupportApiException('Une erreur est survenue');
    }
  }

  /// Adds a message to a ticket.
  ///
  /// Calls `POST /api/v1/support/tickets/:id/messages`.
  Future<SupportTicket> addMessage(String ticketId, AddMessageDto dto) async {
    debugPrint('[SupportApi] Adding message to ticket: $ticketId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/support/tickets/$ticketId/messages');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[SupportApi] POST $uri');
      final response = await ApiClient.client
          .post(uri, headers: headers, body: jsonEncode(dto.toJson()))
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[SupportApi] addMessage: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 400) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw SupportApiException(
          json['message'] as String? ?? 'Données invalides',
          400,
        );
      }

      if (response.statusCode == 404) {
        throw const SupportApiException('Ticket introuvable', 404);
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw SupportApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['ticket'] ?? json['data'] ?? json;
      return SupportTicket.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const SupportApiException('Connexion impossible');
    } on http.ClientException {
      throw const SupportApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is SupportApiException || e is AuthException) rethrow;
      debugPrint('[SupportApi] addMessage error: $e');
      throw const SupportApiException('Une erreur est survenue');
    }
  }

  /// Closes a ticket.
  ///
  /// Calls `PATCH /api/v1/support/tickets/:id/close`.
  Future<SupportTicket> closeTicket(String ticketId) async {
    debugPrint('[SupportApi] Closing ticket: $ticketId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/support/tickets/$ticketId/close');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[SupportApi] PATCH $uri');
      final response = await ApiClient.client
          .patch(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[SupportApi] closeTicket: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        throw const SupportApiException('Ticket introuvable', 404);
      }

      if (response.statusCode != 200) {
        throw SupportApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['ticket'] ?? json['data'] ?? json;
      return SupportTicket.fromJson(data as Map<String, dynamic>);
    } on TimeoutException {
      throw const SupportApiException('Connexion impossible');
    } on http.ClientException {
      throw const SupportApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is SupportApiException || e is AuthException) rethrow;
      debugPrint('[SupportApi] closeTicket error: $e');
      throw const SupportApiException('Une erreur est survenue');
    }
  }
}
