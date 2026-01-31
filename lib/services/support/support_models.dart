/// Support ticket models for WorkOn.
///
/// Data structures for customer support tickets and messages.
///
/// **FL-SUPPORT:** Initial implementation.
library;

/// Priority levels for support tickets.
enum TicketPriority {
  low,
  medium,
  high,
  urgent;

  String get displayName {
    switch (this) {
      case TicketPriority.low:
        return 'Faible';
      case TicketPriority.medium:
        return 'Moyenne';
      case TicketPriority.high:
        return 'Haute';
      case TicketPriority.urgent:
        return 'Urgente';
    }
  }

  static TicketPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return TicketPriority.low;
      case 'high':
        return TicketPriority.high;
      case 'urgent':
        return TicketPriority.urgent;
      default:
        return TicketPriority.medium;
    }
  }
}

/// Status of a support ticket.
enum TicketStatus {
  open,
  inProgress,
  waitingResponse,
  resolved,
  closed;

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Ouvert';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.waitingResponse:
        return 'En attente';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        return 'Fermé';
    }
  }

  bool get isActive => this == TicketStatus.open || 
                       this == TicketStatus.inProgress || 
                       this == TicketStatus.waitingResponse;

  static TicketStatus fromString(String value) {
    switch (value.toLowerCase().replaceAll('_', '')) {
      case 'open':
        return TicketStatus.open;
      case 'inprogress':
        return TicketStatus.inProgress;
      case 'waitingresponse':
        return TicketStatus.waitingResponse;
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.open;
    }
  }
}

/// Category of a support ticket.
enum TicketCategory {
  general,
  payment,
  mission,
  account,
  technical,
  safety,
  other;

  String get displayName {
    switch (this) {
      case TicketCategory.general:
        return 'Général';
      case TicketCategory.payment:
        return 'Paiement';
      case TicketCategory.mission:
        return 'Mission';
      case TicketCategory.account:
        return 'Compte';
      case TicketCategory.technical:
        return 'Technique';
      case TicketCategory.safety:
        return 'Sécurité';
      case TicketCategory.other:
        return 'Autre';
    }
  }

  static TicketCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'general':
        return TicketCategory.general;
      case 'payment':
        return TicketCategory.payment;
      case 'mission':
        return TicketCategory.mission;
      case 'account':
        return TicketCategory.account;
      case 'technical':
        return TicketCategory.technical;
      case 'safety':
        return TicketCategory.safety;
      default:
        return TicketCategory.other;
    }
  }
}

/// A message in a support ticket.
class TicketMessage {
  const TicketMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isFromSupport,
    this.senderName,
    this.attachments,
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id']?.toString() ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isFromSupport: json['isFromSupport'] as bool? ?? 
                     json['fromSupport'] as bool? ??
                     json['senderType'] == 'support',
      senderName: json['senderName'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  final String id;
  final String content;
  final DateTime createdAt;
  final bool isFromSupport;
  final String? senderName;
  final List<String>? attachments;

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isFromSupport': isFromSupport,
        'senderName': senderName,
        'attachments': attachments,
      };
}

/// A support ticket.
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.updatedAt,
    this.messages = const [],
    this.userId,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id']?.toString() ?? '',
      subject: json['subject'] as String? ?? 'Sans titre',
      status: TicketStatus.fromString(json['status']?.toString() ?? 'open'),
      priority: TicketPriority.fromString(json['priority']?.toString() ?? 'medium'),
      category: TicketCategory.fromString(json['category']?.toString() ?? 'general'),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => TicketMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userId: json['userId']?.toString(),
    );
  }

  final String id;
  final String subject;
  final TicketStatus status;
  final TicketPriority priority;
  final TicketCategory category;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TicketMessage> messages;
  final String? userId;

  /// Returns the last message in the ticket.
  TicketMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Returns true if ticket can receive new messages.
  bool get canAddMessage => status.isActive;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'status': status.name,
        'priority': priority.name,
        'category': category.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
        'userId': userId,
      };
}

/// DTO for creating a new ticket.
class CreateTicketDto {
  const CreateTicketDto({
    required this.subject,
    required this.message,
    this.category = TicketCategory.general,
    this.priority = TicketPriority.medium,
    this.missionId,
  });

  final String subject;
  final String message;
  final TicketCategory category;
  final TicketPriority priority;
  final String? missionId;

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'message': message,
        'category': category.name.toUpperCase(),
        'priority': priority.name.toUpperCase(),
        if (missionId != null) 'missionId': missionId,
      };
}

/// DTO for adding a message to a ticket.
class AddMessageDto {
  const AddMessageDto({
    required this.content,
    this.attachments,
  });

  final String content;
  final List<String>? attachments;

  Map<String, dynamic> toJson() => {
        'content': content,
        if (attachments != null && attachments!.isNotEmpty)
          'attachments': attachments,
      };
}

/// Paginated list of tickets.
class TicketListResponse {
  const TicketListResponse({
    required this.tickets,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) {
    final ticketsJson = json['tickets'] ?? json['data'] ?? json['items'] ?? [];
    return TicketListResponse(
      tickets: (ticketsJson as List<dynamic>)
          .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
    );
  }

  final List<SupportTicket> tickets;
  final int total;
  final int page;
  final int limit;

  bool get hasMore => tickets.length < total && tickets.length >= limit;
}
