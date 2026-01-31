/// Support Service for WorkOn.
///
/// Business logic layer for customer support operations.
///
/// **FL-SUPPORT:** Initial implementation.
library;

import 'package:flutter/foundation.dart';

import 'support_api.dart';
import 'support_models.dart';

/// Service for managing support tickets.
class SupportService {
  SupportService._();

  static final _api = const SupportApi();

  /// Cache for ticket list.
  static List<SupportTicket>? _ticketsCache;
  static DateTime? _ticketsCacheTime;
  static const _cacheDuration = Duration(minutes: 2);

  /// Cache for individual tickets.
  static final Map<String, SupportTicket> _ticketCache = {};

  /// Clears all cached data.
  static void clearCache() {
    _ticketsCache = null;
    _ticketsCacheTime = null;
    _ticketCache.clear();
    debugPrint('[SupportService] Cache cleared');
  }

  /// Returns true if tickets cache is valid.
  static bool _isCacheValid() {
    if (_ticketsCache == null || _ticketsCacheTime == null) return false;
    return DateTime.now().difference(_ticketsCacheTime!) < _cacheDuration;
  }

  /// Gets all tickets for the current user.
  static Future<List<SupportTicket>> getTickets({
    bool forceRefresh = false,
    int page = 1,
    int limit = 20,
  }) async {
    // Check cache for first page
    if (!forceRefresh && page == 1 && _isCacheValid() && _ticketsCache != null) {
      debugPrint('[SupportService] Returning cached tickets');
      return _ticketsCache!;
    }

    // Fetch from API
    debugPrint('[SupportService] Fetching tickets');
    final response = await _api.getTickets(page: page, limit: limit);

    // Update cache for first page
    if (page == 1) {
      _ticketsCache = response.tickets;
      _ticketsCacheTime = DateTime.now();
    }

    // Update individual ticket cache
    for (final ticket in response.tickets) {
      _ticketCache[ticket.id] = ticket;
    }

    return response.tickets;
  }

  /// Gets a specific ticket by ID.
  static Future<SupportTicket> getTicket(
    String ticketId, {
    bool forceRefresh = false,
  }) async {
    // Check cache
    if (!forceRefresh && _ticketCache.containsKey(ticketId)) {
      debugPrint('[SupportService] Returning cached ticket: $ticketId');
      return _ticketCache[ticketId]!;
    }

    // Fetch from API
    debugPrint('[SupportService] Fetching ticket: $ticketId');
    final ticket = await _api.getTicket(ticketId);

    // Update cache
    _ticketCache[ticketId] = ticket;

    return ticket;
  }

  /// Creates a new support ticket.
  static Future<SupportTicket> createTicket({
    required String subject,
    required String message,
    TicketCategory category = TicketCategory.general,
    TicketPriority priority = TicketPriority.medium,
    String? missionId,
  }) async {
    debugPrint('[SupportService] Creating ticket: $subject');

    final dto = CreateTicketDto(
      subject: subject,
      message: message,
      category: category,
      priority: priority,
      missionId: missionId,
    );

    final ticket = await _api.createTicket(dto);

    // Invalidate list cache
    _ticketsCache = null;
    _ticketsCacheTime = null;

    // Add to individual cache
    _ticketCache[ticket.id] = ticket;

    return ticket;
  }

  /// Adds a message to a ticket.
  static Future<SupportTicket> addMessage({
    required String ticketId,
    required String content,
    List<String>? attachments,
  }) async {
    debugPrint('[SupportService] Adding message to ticket: $ticketId');

    final dto = AddMessageDto(
      content: content,
      attachments: attachments,
    );

    final ticket = await _api.addMessage(ticketId, dto);

    // Update caches
    _ticketCache[ticketId] = ticket;
    _ticketsCache = null;
    _ticketsCacheTime = null;

    return ticket;
  }

  /// Closes a ticket.
  static Future<SupportTicket> closeTicket(String ticketId) async {
    debugPrint('[SupportService] Closing ticket: $ticketId');

    final ticket = await _api.closeTicket(ticketId);

    // Update caches
    _ticketCache[ticketId] = ticket;
    _ticketsCache = null;
    _ticketsCacheTime = null;

    return ticket;
  }

  /// Gets cached ticket synchronously (may be null).
  static SupportTicket? getCachedTicket(String ticketId) {
    return _ticketCache[ticketId];
  }

  /// Gets count of active tickets (from cache).
  static int get activeTicketCount {
    if (_ticketsCache == null) return 0;
    return _ticketsCache!.where((t) => t.status.isActive).length;
  }
}
