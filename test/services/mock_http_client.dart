/// PR-T4: Mock HTTP Client for Service Tests
///
/// Provides HTTP mocking utilities for testing API services
/// without making real network calls.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

/// Mock implementation of http.Client for testing.
class MockHttpClient extends Mock implements http.Client {}

/// Extension for setting up mock HTTP responses.
extension MockHttpClientSetup on MockHttpClient {
  /// Sets up a GET request to return a specific response.
  void whenGet(
    String urlPattern, {
    int statusCode = 200,
    dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  }) {
    when(() => get(
          any(that: _matchesUrl(urlPattern)),
          headers: any(named: 'headers'),
        )).thenAnswer(
      (_) async => http.Response(
        body is String ? body : jsonEncode(body),
        statusCode,
        headers: headers,
      ),
    );
  }

  /// Sets up a POST request to return a specific response.
  void whenPost(
    String urlPattern, {
    int statusCode = 200,
    dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  }) {
    when(() => post(
          any(that: _matchesUrl(urlPattern)),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer(
      (_) async => http.Response(
        body is String ? body : jsonEncode(body),
        statusCode,
        headers: headers,
      ),
    );
  }

  /// Sets up a PUT request to return a specific response.
  void whenPut(
    String urlPattern, {
    int statusCode = 200,
    dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  }) {
    when(() => put(
          any(that: _matchesUrl(urlPattern)),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer(
      (_) async => http.Response(
        body is String ? body : jsonEncode(body),
        statusCode,
        headers: headers,
      ),
    );
  }

  /// Sets up a DELETE request to return a specific response.
  void whenDelete(
    String urlPattern, {
    int statusCode = 200,
    dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  }) {
    when(() => delete(
          any(that: _matchesUrl(urlPattern)),
          headers: any(named: 'headers'),
        )).thenAnswer(
      (_) async => http.Response(
        body is String ? body : jsonEncode(body ?? {}),
        statusCode,
        headers: headers,
      ),
    );
  }

  /// Sets up any GET request to throw an exception.
  void whenGetThrows(Exception exception) {
    when(() => get(
          any(),
          headers: any(named: 'headers'),
        )).thenThrow(exception);
  }

  /// Sets up any POST request to throw an exception.
  void whenPostThrows(Exception exception) {
    when(() => post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenThrow(exception);
  }
}

/// URL matcher for mocktail.
Matcher<Uri> _matchesUrl(String pattern) {
  return predicate<Uri>(
    (uri) => uri.toString().contains(pattern),
    'URL contains "$pattern"',
  );
}

// ============================================================================
// MOCK JSON PAYLOADS
// ============================================================================

/// Sample JSON payloads for testing.
class MockPayloads {
  // ─────────────────────────────────────────────────────────────────────────
  // AUTH PAYLOADS
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, dynamic> authLoginSuccess({
    String userId = 'user-123',
    String email = 'test@example.com',
    String accessToken = 'mock-access-token',
    String refreshToken = 'mock-refresh-token',
  }) =>
      {
        'user': {
          'id': userId,
          'email': email,
          'name': 'Test User',
          'role': 'WORKER',
          'createdAt': DateTime.now().toIso8601String(),
        },
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      };

  static Map<String, dynamic> authMeSuccess({
    String userId = 'user-123',
    String email = 'test@example.com',
    String role = 'WORKER',
  }) =>
      {
        'id': userId,
        'email': email,
        'name': 'Test User',
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      };

  static Map<String, dynamic> authRefreshSuccess({
    String accessToken = 'new-access-token',
    String refreshToken = 'new-refresh-token',
  }) =>
      {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      };

  // ─────────────────────────────────────────────────────────────────────────
  // MISSION PAYLOADS
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, dynamic> missionSuccess({
    String id = 'mission-123',
    String title = 'Test Mission',
    String status = 'open',
    double price = 100.0,
  }) =>
      {
        'id': id,
        'title': title,
        'description': 'Test description',
        'category': 'cleaning',
        'status': status,
        'price': price,
        'latitude': 45.5017,
        'longitude': -73.5673,
        'city': 'Montreal',
        'address': '123 Test St',
        'createdByUserId': 'user-employer-1',
        'assignedToUserId': null,
        'distanceKm': 2.5,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

  static List<Map<String, dynamic>> missionsListSuccess({int count = 3}) {
    return List.generate(
      count,
      (i) => missionSuccess(
        id: 'mission-$i',
        title: 'Mission #$i',
        price: 50.0 + (i * 25),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EARNINGS PAYLOADS
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, dynamic> earningsSummarySuccess({
    double totalLifetimeNet = 1000.0,
    double totalAvailable = 500.0,
    double totalPending = 200.0,
    double totalPaid = 300.0,
    int completedMissionsCount = 10,
    int paidMissionsCount = 8,
  }) =>
      {
        'totalLifetimeGross': totalLifetimeNet * 1.15,
        'totalLifetimeNet': totalLifetimeNet,
        'totalAvailable': totalAvailable,
        'totalPending': totalPending,
        'totalPaid': totalPaid,
        'completedMissionsCount': completedMissionsCount,
        'paidMissionsCount': paidMissionsCount,
        'commissionRate': 0.15,
        'currency': 'CAD',
      };

  static Map<String, dynamic> earningsHistorySuccess({int count = 5}) => {
        'transactions': List.generate(
          count,
          (i) => {
            'missionId': 'mission-$i',
            'missionTitle': 'Mission #$i',
            'clientName': 'Client $i',
            'grossAmount': 100.0 + (i * 20),
            'commissionAmount': 15.0 + (i * 3),
            'netAmount': 85.0 + (i * 17),
            'status': i % 2 == 0 ? 'paid' : 'available',
            'date': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
          },
        ),
        'nextCursor': count > 3 ? 'cursor-abc' : null,
      };

  static Map<String, dynamic> earningByMissionSuccess({
    String missionId = 'mission-123',
  }) =>
      {
        'missionId': missionId,
        'missionTitle': 'Test Mission',
        'clientName': 'Test Client',
        'grossAmount': 100.0,
        'commissionAmount': 15.0,
        'netAmount': 85.0,
        'status': 'available',
        'date': DateTime.now().toIso8601String(),
      };

  // ─────────────────────────────────────────────────────────────────────────
  // MESSAGES PAYLOADS
  // ─────────────────────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> conversationsSuccess({int count = 2}) {
    return List.generate(
      count,
      (i) => {
        'missionId': 'mission-$i',
        'missionTitle': 'Mission #$i',
        'otherUserId': 'user-$i',
        'otherUserName': 'User $i',
        'otherUserPhotoUrl': null,
        'lastMessage': 'Last message $i',
        'lastMessageAt': DateTime.now().subtract(Duration(hours: i)).toIso8601String(),
        'unreadCount': i,
      },
    );
  }

  static List<Map<String, dynamic>> messagesSuccess({int count = 5}) {
    return List.generate(
      count,
      (i) => {
        'id': 'msg-$i',
        'missionId': 'mission-1',
        'content': 'Message content $i',
        'senderId': i % 2 == 0 ? 'user-1' : 'user-2',
        'senderRole': i % 2 == 0 ? 'WORKER' : 'EMPLOYER',
        'createdAt': DateTime.now().subtract(Duration(minutes: count - i)).toIso8601String(),
        'read': i < count - 1,
      },
    );
  }

  static Map<String, dynamic> messageSendSuccess({
    String missionId = 'mission-1',
    String content = 'Test message',
  }) =>
      {
        'message': {
          'id': 'msg-new',
          'missionId': missionId,
          'content': content,
          'senderId': 'user-1',
          'senderRole': 'WORKER',
          'createdAt': DateTime.now().toIso8601String(),
          'read': false,
        },
      };

  static Map<String, dynamic> unreadCountSuccess({int count = 3}) => {
        'count': count,
      };

  // ─────────────────────────────────────────────────────────────────────────
  // ERROR PAYLOADS
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, dynamic> errorPayload({
    String message = 'An error occurred',
    String? errorCode,
  }) =>
      {
        'message': message,
        if (errorCode != null) 'errorCode': errorCode,
      };

  static Map<String, dynamic> validationError({
    String message = 'Validation failed',
    List<String> errors = const ['Field is required'],
  }) =>
      {
        'message': message,
        'errors': errors,
      };
}


