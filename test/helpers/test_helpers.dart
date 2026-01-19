/// WorkOn Flutter Widget Test Helpers
///
/// PR-T3: Provides test utilities for widget testing without network dependencies.
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   TestApp(
///     child: MyWidget(),
///   ),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ============================================================================
// TEST APP WRAPPER
// ============================================================================

/// A minimal MaterialApp wrapper for widget testing.
///
/// Provides:
/// - MaterialApp with basic theme
/// - No network dependencies
/// - No SharedPreferences initialization
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   TestApp(child: MyWidget()),
/// );
/// ```
class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.child,
    this.locale = const Locale('fr', 'FR'),
    this.navigatorObservers = const [],
    this.onGenerateRoute,
  });

  final Widget child;
  final Locale locale;
  final List<NavigatorObserver> navigatorObservers;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: child,
      navigatorObservers: navigatorObservers,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

/// A scaffold wrapper for testing widgets that need a Scaffold ancestor.
class TestScaffold extends StatelessWidget {
  const TestScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.drawer,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: child,
    );
  }
}

// ============================================================================
// MOCK DATA FACTORIES
// ============================================================================

/// Factory for creating mock mission data.
class MockMission {
  static Map<String, dynamic> create({
    String? id,
    String? title,
    String? description,
    String? city,
    String? status,
    double? price,
    DateTime? createdAt,
  }) {
    return {
      'id': id ?? 'mission_${DateTime.now().millisecondsSinceEpoch}',
      'title': title ?? 'Test Mission',
      'description': description ?? 'Test description',
      'city': city ?? 'Montreal',
      'address': '123 Test Street',
      'latitude': 45.5017,
      'longitude': -73.5673,
      'price': price ?? 100.0,
      'status': status ?? 'open',
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static List<Map<String, dynamic>> createList(int count, {String? status}) {
    return List.generate(
      count,
      (i) => create(
        id: 'mission_$i',
        title: 'Mission #$i',
        price: 50.0 + (i * 25),
        status: status,
      ),
    );
  }
}

/// Factory for creating mock user data.
class MockUser {
  static Map<String, dynamic> create({
    String? id,
    String? email,
    String? name,
    String? role,
  }) {
    return {
      'id': id ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email ?? 'test@example.com',
      'name': name ?? 'Test User',
      'role': role ?? 'WORKER',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

/// Factory for creating mock earnings data.
class MockEarnings {
  static Map<String, dynamic> createSummary({
    double? totalLifetimeNet,
    double? totalAvailable,
    double? totalPending,
    double? totalPaid,
    int? completedMissionsCount,
  }) {
    return {
      'totalLifetimeGross': (totalLifetimeNet ?? 1000.0) * 1.15,
      'totalLifetimeNet': totalLifetimeNet ?? 1000.0,
      'totalAvailable': totalAvailable ?? 500.0,
      'totalPending': totalPending ?? 200.0,
      'totalPaid': totalPaid ?? 300.0,
      'completedMissionsCount': completedMissionsCount ?? 10,
      'paidMissionsCount': 8,
      'commissionRate': 0.15,
      'currency': 'CAD',
    };
  }

  static Map<String, dynamic> createTransaction({
    String? missionId,
    String? missionTitle,
    String? clientName,
    double? grossAmount,
    String? status,
  }) {
    final gross = grossAmount ?? 100.0;
    final commission = gross * 0.15;
    return {
      'missionId': missionId ?? 'mission_1',
      'missionTitle': missionTitle ?? 'Test Mission',
      'clientName': clientName ?? 'Client Name',
      'grossAmount': gross,
      'commissionAmount': commission,
      'netAmount': gross - commission,
      'status': status ?? 'available',
      'date': DateTime.now().toIso8601String(),
    };
  }

  static List<Map<String, dynamic>> createTransactionList(int count) {
    return List.generate(
      count,
      (i) => createTransaction(
        missionId: 'mission_$i',
        missionTitle: 'Mission #$i',
        grossAmount: 50.0 + (i * 25),
      ),
    );
  }
}

/// Factory for creating mock conversation/message data.
class MockMessage {
  static Map<String, dynamic> create({
    String? id,
    String? missionId,
    String? content,
    String? senderId,
    DateTime? createdAt,
  }) {
    return {
      'id': id ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'missionId': missionId ?? 'mission_1',
      'content': content ?? 'Test message',
      'senderId': senderId ?? 'user_1',
      'senderRole': 'WORKER',
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'read': false,
    };
  }

  static List<Map<String, dynamic>> createList(int count, {String? missionId}) {
    return List.generate(
      count,
      (i) => create(
        id: 'msg_$i',
        missionId: missionId,
        content: 'Message #$i',
        createdAt: DateTime.now().subtract(Duration(minutes: count - i)),
      ),
    );
  }

  static Map<String, dynamic> createConversation({
    String? missionId,
    String? missionTitle,
    String? lastMessage,
    int? unreadCount,
  }) {
    return {
      'missionId': missionId ?? 'mission_1',
      'missionTitle': missionTitle ?? 'Test Mission',
      'otherUserId': 'user_other',
      'otherUserName': 'Other User',
      'lastMessage': lastMessage ?? 'Last message content',
      'lastMessageAt': DateTime.now().toIso8601String(),
      'unreadCount': unreadCount ?? 0,
    };
  }
}

// ============================================================================
// WIDGET TEST KEYS
// ============================================================================

/// Standard test keys for finding widgets in tests.
///
/// Usage in production code:
/// ```dart
/// TextField(
///   key: TestKeys.loginEmail,
///   ...
/// )
/// ```
///
/// Usage in tests:
/// ```dart
/// expect(find.byKey(TestKeys.loginEmail), findsOneWidget);
/// ```
class TestKeys {
  // Auth
  static const loginEmail = Key('login_email');
  static const loginPassword = Key('login_password');
  static const loginButton = Key('login_button');
  static const signupButton = Key('signup_button');

  // Navigation
  static const drawerMenu = Key('drawer_menu');
  static const bottomNav = Key('bottom_nav');
  static const backButton = Key('back_button');

  // Jobs
  static const jobsList = Key('jobs_list');
  static const jobsLoading = Key('jobs_loading');
  static const jobsEmpty = Key('jobs_empty');
  static const jobsError = Key('jobs_error');
  static const jobCard = Key('job_card');

  // Earnings
  static const earningsSummary = Key('earnings_summary');
  static const earningsHistory = Key('earnings_history');
  static const earningsLoading = Key('earnings_loading');

  // Chat
  static const chatList = Key('chat_list');
  static const chatInput = Key('chat_input');
  static const chatSendButton = Key('chat_send_button');
  static const messageItem = Key('message_item');

  // Profile
  static const profileAvatar = Key('profile_avatar');
  static const profileName = Key('profile_name');
  static const profileEmail = Key('profile_email');

  // Map
  static const missionsMap = Key('missions_map');
  static const mapMarker = Key('map_marker');
}

// ============================================================================
// TEST UTILITIES
// ============================================================================

/// Pumps a widget and settles all animations.
///
/// Use this instead of pumpWidget + pumpAndSettle for most cases.
extension WidgetTesterExtension on dynamic {
  /// Helper method docs placeholder
}

/// Finds a widget by text, case-insensitive.
Finder findTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.data != null &&
        widget.data!.toLowerCase().contains(text.toLowerCase()),
  );
}

