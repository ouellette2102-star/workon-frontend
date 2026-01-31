/// Mission Events API for WorkOn.
///
/// **FL-EVENTS:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../auth/auth_service.dart';
import '../auth/auth_errors.dart';

/// Exception thrown by [MissionEventsApi].
class MissionEventsApiException implements Exception {
  final String message;
  final int? statusCode;

  const MissionEventsApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'MissionEventsApiException: $message';
}

/// Event types for missions.
enum MissionEventType {
  missionCreated('MISSION_CREATED', 'Mission créée'),
  missionPublished('MISSION_PUBLISHED', 'Mission publiée'),
  missionAccepted('MISSION_ACCEPTED', 'Mission acceptée'),
  missionStarted('MISSION_STARTED', 'Mission démarrée'),
  missionCompleted('MISSION_COMPLETED', 'Mission terminée'),
  missionCanceled('MISSION_CANCELED', 'Mission annulée'),
  missionExpired('MISSION_EXPIRED', 'Mission expirée'),
  paymentAuthorized('PAYMENT_AUTHORIZED', 'Paiement autorisé'),
  paymentCaptured('PAYMENT_CAPTURED', 'Paiement capturé'),
  paymentCanceled('PAYMENT_CANCELED', 'Paiement annulé'),
  photoUploaded('PHOTO_UPLOADED', 'Photo ajoutée'),
  offerSubmitted('OFFER_SUBMITTED', 'Offre soumise'),
  offerAccepted('OFFER_ACCEPTED', 'Offre acceptée'),
  offerDeclined('OFFER_DECLINED', 'Offre refusée');

  const MissionEventType(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Gets the icon for this event type.
  String get iconName {
    switch (this) {
      case MissionEventType.missionCreated:
        return 'add_circle';
      case MissionEventType.missionPublished:
        return 'publish';
      case MissionEventType.missionAccepted:
        return 'handshake';
      case MissionEventType.missionStarted:
        return 'play_circle';
      case MissionEventType.missionCompleted:
        return 'check_circle';
      case MissionEventType.missionCanceled:
        return 'cancel';
      case MissionEventType.missionExpired:
        return 'timer_off';
      case MissionEventType.paymentAuthorized:
        return 'lock';
      case MissionEventType.paymentCaptured:
        return 'payments';
      case MissionEventType.paymentCanceled:
        return 'money_off';
      case MissionEventType.photoUploaded:
        return 'photo_camera';
      case MissionEventType.offerSubmitted:
        return 'send';
      case MissionEventType.offerAccepted:
        return 'thumb_up';
      case MissionEventType.offerDeclined:
        return 'thumb_down';
    }
  }

  static MissionEventType? fromString(String value) {
    for (final type in MissionEventType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

/// A mission event.
class MissionEvent {
  const MissionEvent({
    required this.id,
    required this.missionId,
    required this.type,
    required this.createdAt,
    this.actorUserId,
    this.targetUserId,
    this.payload,
  });

  factory MissionEvent.fromJson(Map<String, dynamic> json) {
    return MissionEvent(
      id: json['id']?.toString() ?? '',
      missionId: json['missionId']?.toString() ?? '',
      type: MissionEventType.fromString(json['type']?.toString() ?? '') ??
          MissionEventType.missionCreated,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      actorUserId: json['actorUserId']?.toString(),
      targetUserId: json['targetUserId']?.toString(),
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final String missionId;
  final MissionEventType type;
  final DateTime createdAt;
  final String? actorUserId;
  final String? targetUserId;
  final Map<String, dynamic>? payload;

  Map<String, dynamic> toJson() => {
        'id': id,
        'missionId': missionId,
        'type': type.value,
        'createdAt': createdAt.toIso8601String(),
        'actorUserId': actorUserId,
        'targetUserId': targetUserId,
        'payload': payload,
      };
}

/// Paginated events response.
class PaginatedEventsResponse {
  const PaginatedEventsResponse({
    required this.events,
    this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedEventsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedEventsResponse(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => MissionEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  final List<MissionEvent> events;
  final String? nextCursor;
  final bool hasMore;
}

/// API client for mission events.
class MissionEventsApi {
  const MissionEventsApi();

  /// Gets events for a mission.
  ///
  /// Calls `GET /api/v1/missions/:missionId/events`.
  Future<PaginatedEventsResponse> getMissionEvents(
    String missionId, {
    int? limit,
    String? cursor,
  }) async {
    debugPrint('[MissionEventsApi] Getting events for mission: $missionId');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final params = <String, String>{};
    if (limit != null) params['limit'] = limit.toString();
    if (cursor != null) params['cursor'] = cursor;

    final baseUri = ApiClient.buildUri('/missions/$missionId/events');
    final uri = params.isEmpty ? baseUri : baseUri.replace(queryParameters: params);
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionEventsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionEventsApi] getMissionEvents: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        return const PaginatedEventsResponse(events: [], hasMore: false);
      }

      if (response.statusCode != 200) {
        throw MissionEventsApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PaginatedEventsResponse.fromJson(json);
    } on TimeoutException {
      throw const MissionEventsApiException('Connexion impossible');
    } on http.ClientException {
      throw const MissionEventsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionEventsApiException || e is AuthException) rethrow;
      debugPrint('[MissionEventsApi] getMissionEvents error: $e');
      throw const MissionEventsApiException('Une erreur est survenue');
    }
  }

  /// Gets events targeting the current user.
  ///
  /// Calls `GET /api/v1/me/events`.
  Future<PaginatedEventsResponse> getMyEvents({
    int? limit,
    String? cursor,
  }) async {
    debugPrint('[MissionEventsApi] Getting my events');

    if (!AuthService.hasSession) {
      throw const UnauthorizedException();
    }

    final token = AuthService.session.token;
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final params = <String, String>{};
    if (limit != null) params['limit'] = limit.toString();
    if (cursor != null) params['cursor'] = cursor;

    final baseUri = ApiClient.buildUri('/me/events');
    final uri = params.isEmpty ? baseUri : baseUri.replace(queryParameters: params);
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionEventsApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionEventsApi] getMyEvents: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode != 200) {
        throw MissionEventsApiException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PaginatedEventsResponse.fromJson(json);
    } on TimeoutException {
      throw const MissionEventsApiException('Connexion impossible');
    } on http.ClientException {
      throw const MissionEventsApiException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionEventsApiException || e is AuthException) rethrow;
      debugPrint('[MissionEventsApi] getMyEvents error: $e');
      throw const MissionEventsApiException('Une erreur est survenue');
    }
  }
}
