/// Messages API client for WorkOn.
///
/// **PR-F19:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../auth/auth_service.dart';
import 'message_models.dart';

/// API client for messaging endpoints.
class MessagesApi {
  const MessagesApi();

  /// Fetches all conversations for the current user.
  ///
  /// Calls `GET /conversations` with Bearer token.
  Future<List<Conversation>> getConversations() async {
    if (!AuthService.hasSession) {
      debugPrint('[MessagesApi] getConversations: no session');
      throw const MessagesApiException('Pas de session active');
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[MessagesApi] getConversations: no token');
      throw const MessagesApiException('Token non disponible');
    }

    final uri = ApiClient.buildUri('/conversations');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MessagesApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MessagesApi] getConversations: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const MessagesApiException('Session expirée');
      }

      if (response.statusCode >= 500) {
        throw MessagesApiException('Erreur serveur: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        throw MessagesApiException('Erreur: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> data = body is List
          ? body
          : (body['conversations'] ?? body['data'] ?? []);

      return data
          .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      debugPrint('[MessagesApi] getConversations: timeout');
      throw const MessagesApiException('Connexion timeout');
    } on MessagesApiException {
      rethrow;
    } catch (e) {
      debugPrint('[MessagesApi] getConversations: error: $e');
      throw MessagesApiException('Erreur réseau: $e');
    }
  }

  /// Fetches messages for a conversation.
  ///
  /// Calls `GET /conversations/{id}/messages` with Bearer token.
  Future<List<Message>> getMessages(String conversationId) async {
    if (!AuthService.hasSession) {
      debugPrint('[MessagesApi] getMessages: no session');
      throw const MessagesApiException('Pas de session active');
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[MessagesApi] getMessages: no token');
      throw const MessagesApiException('Token non disponible');
    }

    final uri = ApiClient.buildUri('/conversations/$conversationId/messages');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MessagesApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MessagesApi] getMessages: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const MessagesApiException('Session expirée');
      }

      if (response.statusCode == 404) {
        throw const MessagesApiException('Conversation introuvable');
      }

      if (response.statusCode >= 500) {
        throw MessagesApiException('Erreur serveur: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        throw MessagesApiException('Erreur: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> data =
          body is List ? body : (body['messages'] ?? body['data'] ?? []);

      return data
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      debugPrint('[MessagesApi] getMessages: timeout');
      throw const MessagesApiException('Connexion timeout');
    } on MessagesApiException {
      rethrow;
    } catch (e) {
      debugPrint('[MessagesApi] getMessages: error: $e');
      throw MessagesApiException('Erreur réseau: $e');
    }
  }

  /// Sends a message in a conversation.
  ///
  /// Calls `POST /conversations/{id}/messages` with Bearer token.
  Future<Message> sendMessage(String conversationId, String text) async {
    if (!AuthService.hasSession) {
      debugPrint('[MessagesApi] sendMessage: no session');
      throw const MessagesApiException('Pas de session active');
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[MessagesApi] sendMessage: no token');
      throw const MessagesApiException('Token non disponible');
    }

    final uri = ApiClient.buildUri('/conversations/$conversationId/messages');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MessagesApi] POST $uri');
      final response = await ApiClient.client
          .post(
            uri,
            headers: headers,
            body: jsonEncode({'text': text}),
          )
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MessagesApi] sendMessage: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const MessagesApiException('Session expirée');
      }

      if (response.statusCode == 404) {
        throw const MessagesApiException('Conversation introuvable');
      }

      if (response.statusCode >= 500) {
        throw MessagesApiException('Erreur serveur: ${response.statusCode}');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw MessagesApiException('Erreur: ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final messageData = body['message'] ?? body;
      return Message.fromJson(messageData as Map<String, dynamic>);
    } on TimeoutException {
      debugPrint('[MessagesApi] sendMessage: timeout');
      throw const MessagesApiException('Connexion timeout');
    } on MessagesApiException {
      rethrow;
    } catch (e) {
      debugPrint('[MessagesApi] sendMessage: error: $e');
      throw MessagesApiException('Erreur réseau: $e');
    }
  }
}

/// Exception thrown by [MessagesApi] operations.
class MessagesApiException implements Exception {
  const MessagesApiException(this.message);

  final String message;

  @override
  String toString() => 'MessagesApiException: $message';
}

