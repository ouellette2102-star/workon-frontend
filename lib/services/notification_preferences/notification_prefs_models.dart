/// Notification preferences models for WorkOn.
///
/// **FL-NOTIF-PREFS:** Initial implementation.
library;

/// Types of notifications available.
enum NotificationType {
  // Mission lifecycle
  missionNewOffer('MISSION_NEW_OFFER', 'Nouvelles offres'),
  missionOfferAccepted('MISSION_OFFER_ACCEPTED', 'Offre acceptée'),
  missionStarted('MISSION_STARTED', 'Mission démarrée'),
  missionCompleted('MISSION_COMPLETED', 'Mission terminée'),
  missionCancelled('MISSION_CANCELLED', 'Mission annulée'),

  // Messages
  messageNew('MESSAGE_NEW', 'Nouveaux messages'),
  messageUnreadReminder('MESSAGE_UNREAD_REMINDER', 'Rappel messages non lus'),

  // Payments
  paymentReceived('PAYMENT_RECEIVED', 'Paiement reçu'),
  paymentSent('PAYMENT_SENT', 'Paiement envoyé'),
  paymentFailed('PAYMENT_FAILED', 'Paiement échoué'),
  payoutProcessed('PAYOUT_PROCESSED', 'Virement traité'),

  // Reviews
  reviewReceived('REVIEW_RECEIVED', 'Avis reçu'),
  reviewReminder('REVIEW_REMINDER', 'Rappel laisser un avis'),

  // Marketing
  marketingPromo('MARKETING_PROMO', 'Promotions'),
  marketingNewsletter('MARKETING_NEWSLETTER', 'Newsletter');

  const NotificationType(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Gets the category for grouping in UI.
  String get category {
    if (value.startsWith('MISSION_')) return 'Missions';
    if (value.startsWith('MESSAGE_')) return 'Messages';
    if (value.startsWith('PAYMENT_') || value.startsWith('PAYOUT_')) return 'Paiements';
    if (value.startsWith('REVIEW_')) return 'Avis';
    if (value.startsWith('MARKETING_')) return 'Marketing';
    return 'Autre';
  }

  static NotificationType? fromString(String value) {
    for (final type in NotificationType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

/// A notification preference.
class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.userId,
    required this.notificationType,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.timezone,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      notificationType: NotificationType.fromString(
            json['notificationType']?.toString() ?? '',
          ) ??
          NotificationType.missionNewOffer,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String?,
      quietHoursEnd: json['quietHoursEnd'] as String?,
      timezone: json['timezone'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  final String id;
  final String userId;
  final NotificationType notificationType;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final String? timezone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Returns true if at least one channel is enabled.
  bool get isEnabled => pushEnabled || emailEnabled || smsEnabled;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'notificationType': notificationType.value,
        'pushEnabled': pushEnabled,
        'emailEnabled': emailEnabled,
        'smsEnabled': smsEnabled,
        'quietHoursStart': quietHoursStart,
        'quietHoursEnd': quietHoursEnd,
        'timezone': timezone,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  NotificationPreference copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    String? timezone,
  }) {
    return NotificationPreference(
      id: id,
      userId: userId,
      notificationType: notificationType,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// DTO for updating a preference.
class UpdatePreferenceDto {
  const UpdatePreferenceDto({
    this.pushEnabled,
    this.emailEnabled,
    this.smsEnabled,
  });

  final bool? pushEnabled;
  final bool? emailEnabled;
  final bool? smsEnabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pushEnabled != null) map['pushEnabled'] = pushEnabled;
    if (emailEnabled != null) map['emailEnabled'] = emailEnabled;
    if (smsEnabled != null) map['smsEnabled'] = smsEnabled;
    return map;
  }
}

/// DTO for setting quiet hours.
class SetQuietHoursDto {
  const SetQuietHoursDto({
    this.quietHoursStart,
    this.quietHoursEnd,
    this.timezone,
  });

  /// Start time in "HH:MM" format (24h).
  final String? quietHoursStart;

  /// End time in "HH:MM" format (24h).
  final String? quietHoursEnd;

  /// Timezone (e.g., "America/Montreal").
  final String? timezone;

  Map<String, dynamic> toJson() => {
        'quietHoursStart': quietHoursStart,
        'quietHoursEnd': quietHoursEnd,
        'timezone': timezone,
      };
}
