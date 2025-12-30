/// Offer models for WorkOn.
///
/// Data models for user applications/offers.
///
/// **PR-F16:** Initial implementation.
library;

import '../missions/mission_models.dart';

/// Status of an offer/application.
enum OfferStatus {
  pending,
  accepted,
  rejected,
  cancelled,
  expired,
  unknown;

  static OfferStatus fromString(String? value) {
    if (value == null) return OfferStatus.unknown;
    switch (value.toLowerCase()) {
      case 'pending':
      case 'en_attente':
        return OfferStatus.pending;
      case 'accepted':
      case 'accepté':
      case 'acceptee':
        return OfferStatus.accepted;
      case 'rejected':
      case 'refusé':
      case 'refusee':
        return OfferStatus.rejected;
      case 'cancelled':
      case 'annulé':
      case 'annulee':
        return OfferStatus.cancelled;
      case 'expired':
      case 'expiré':
      case 'expiree':
        return OfferStatus.expired;
      default:
        return OfferStatus.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case OfferStatus.pending:
        return 'En attente';
      case OfferStatus.accepted:
        return 'Acceptée';
      case OfferStatus.rejected:
        return 'Refusée';
      case OfferStatus.cancelled:
        return 'Annulée';
      case OfferStatus.expired:
        return 'Expirée';
      case OfferStatus.unknown:
        return 'Inconnu';
    }
  }
}

/// Represents a user's application/offer for a mission.
class Offer {
  final String id;
  final String missionId;
  final String? userId;
  final OfferStatus status;
  final String? message;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Optional embedded mission data (if backend includes it).
  final Mission? mission;

  const Offer({
    required this.id,
    required this.missionId,
    this.userId,
    required this.status,
    this.message,
    required this.createdAt,
    this.updatedAt,
    this.mission,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    // Parse mission if embedded
    Mission? mission;
    if (json['mission'] is Map<String, dynamic>) {
      try {
        mission = Mission.fromJson(json['mission'] as Map<String, dynamic>);
      } catch (e) {
        // Ignore parse errors for embedded mission
      }
    }

    return Offer(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      missionId: (json['missionId'] ?? json['mission_id'] ?? 
          (json['mission'] is Map ? json['mission']['id'] : '') ?? '').toString(),
      userId: json['userId']?.toString() ?? json['user_id']?.toString(),
      status: OfferStatus.fromString(json['status']?.toString()),
      message: json['message']?.toString(),
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt'] ?? json['updated_at']),
      mission: mission,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'missionId': missionId,
        'userId': userId,
        'status': status.name,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Returns true if the offer is still active (not rejected/cancelled/expired).
  bool get isActive =>
      status == OfferStatus.pending || status == OfferStatus.accepted;

  @override
  String toString() => 'Offer(id: $id, missionId: $missionId, status: $status)';
}

