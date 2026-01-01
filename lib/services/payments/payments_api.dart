/// Payments API client for WorkOn.
///
/// Handles HTTP requests to the payments-local backend endpoints.
///
/// **PR-RC1:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/services/api/api_client.dart';
import '/services/auth/auth_errors.dart';
import '/services/auth/auth_service.dart';
import 'payment_models.dart';

/// Exception thrown by [PaymentsApi].
class PaymentsApiException implements Exception {
  final String message;
  const PaymentsApiException([this.message = 'Payment error']);

  @override
  String toString() => message;
}

/// API client for payment operations.
///
/// Endpoints:
/// - POST /api/v1/payments-local/intent - Create PaymentIntent
///
/// Example:
/// ```dart
/// final api = PaymentsApi();
/// final intent = await api.createPaymentIntent(missionId: 'mission123');
/// // Use intent.clientSecret with Stripe SDK
/// ```
class PaymentsApi {
  /// Creates a PaymentIntent for a completed mission.
  ///
  /// Calls `POST /api/v1/payments-local/intent`.
  ///
  /// Returns [PaymentIntentResponse] with clientSecret for Stripe confirmation.
  ///
  /// Throws:
  /// - [UnauthorizedException] if not authenticated
  /// - [PaymentsApiException] on other errors
  Future<PaymentIntentResponse> createPaymentIntent({
    required String missionId,
  }) async {
    debugPrint('[PaymentsApi] Creating payment intent for mission: $missionId');

    // Check auth
    if (!AuthService.hasSession) {
      debugPrint('[PaymentsApi] No active session');
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      debugPrint('[PaymentsApi] No token available');
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/payments-local/intent');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'missionId': missionId,
    });

    try {
      final response = await ApiClient.client
          .post(uri, headers: headers, body: body)
          .timeout(ApiClient.connectionTimeout);

      return _handlePaymentIntentResponse(response);
    } on TimeoutException {
      debugPrint('[PaymentsApi] Request timeout');
      throw const PaymentsApiException('Connexion timeout');
    } on http.ClientException catch (e) {
      debugPrint('[PaymentsApi] Client error: $e');
      throw const PaymentsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is PaymentsApiException || e is UnauthorizedException) rethrow;
      debugPrint('[PaymentsApi] Unexpected error: $e');
      throw const PaymentsApiException();
    }
  }

  /// Handles the PaymentIntent response.
  PaymentIntentResponse _handlePaymentIntentResponse(http.Response response) {
    debugPrint('[PaymentsApi] Response status: ${response.statusCode}');

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const UnauthorizedException();
    }

    if (response.statusCode == 404) {
      throw const PaymentsApiException('Mission non trouvée');
    }

    if (response.statusCode == 503) {
      throw const PaymentsApiException(
          'Service de paiement non disponible. Réessayez plus tard.');
    }

    if (response.statusCode >= 500) {
      throw const PaymentsApiException('Erreur serveur');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorBody = _tryParseError(response.body);
      throw PaymentsApiException(errorBody ?? 'Erreur de paiement');
    }

    try {
      final json = jsonDecode(response.body);
      final data = json is Map<String, dynamic> ? (json['data'] ?? json) : json;

      return PaymentIntentResponse.fromJson(data as Map<String, dynamic>);
    } on FormatException catch (e) {
      debugPrint('[PaymentsApi] JSON parse error: $e');
      throw const PaymentsApiException('Réponse invalide du serveur');
    }
  }

  /// Tries to parse error message from response body.
  String? _tryParseError(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        return json['message'] as String? ?? json['error'] as String?;
      }
    } catch (_) {}
    return null;
  }
}

