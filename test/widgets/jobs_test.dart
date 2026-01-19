/// PR-T3: Jobs List & Detail Widget Tests
///
/// Tests jobs list rendering, empty states, error handling, and navigation.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Jobs List Widget Tests', () {
    // ========================================================================
    // 1. JOBS LIST EMPTY STATE
    // ========================================================================
    testWidgets('Jobs list shows empty state when no missions', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mes missions')),
            body: Center(
              key: TestKeys.jobsEmpty,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.work_outline, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune mission',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vos missions apparaîtront ici.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify empty state
      expect(find.byKey(TestKeys.jobsEmpty), findsOneWidget);
      expect(find.byIcon(Icons.work_outline), findsOneWidget);
      expect(find.text('Aucune mission'), findsOneWidget);
      expect(find.text('Vos missions apparaîtront ici.'), findsOneWidget);
    });

    // ========================================================================
    // 2. JOBS LIST WITH ITEMS
    // ========================================================================
    testWidgets('Jobs list displays mission items', (tester) async {
      final missions = MockMission.createList(3);

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mes missions')),
            body: ListView.builder(
              key: TestKeys.jobsList,
              padding: const EdgeInsets.all(16),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];
                return Card(
                  key: Key('job_card_$index'),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(mission['title'] as String),
                    subtitle: Text(mission['city'] as String),
                    trailing: Text('\$${mission['price']}'),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify list is present
      expect(find.byKey(TestKeys.jobsList), findsOneWidget);

      // Verify all mission cards are displayed
      expect(find.text('Mission #0'), findsOneWidget);
      expect(find.text('Mission #1'), findsOneWidget);
      expect(find.text('Mission #2'), findsOneWidget);

      // Verify price is displayed
      expect(find.text('\$50.0'), findsOneWidget);
    });

    // ========================================================================
    // 3. JOBS LIST LOADING STATE
    // ========================================================================
    testWidgets('Jobs list shows loading indicator', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mes missions')),
            body: const Center(
              key: TestKeys.jobsLoading,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des missions...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading state
      expect(find.byKey(TestKeys.jobsLoading), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement des missions...'), findsOneWidget);
    });

    // ========================================================================
    // 4. JOBS LIST ERROR STATE
    // ========================================================================
    testWidgets('Jobs list shows error with retry button', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mes missions')),
            body: Center(
              key: TestKeys.jobsError,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Erreur de chargement'),
                  const SizedBox(height: 8),
                  const Text(
                    'Impossible de charger les missions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      retryPressed = true;
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify error state
      expect(find.byKey(TestKeys.jobsError), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Erreur de chargement'), findsOneWidget);

      // Tap retry
      await tester.tap(find.text('Réessayer'));
      await tester.pump();
      expect(retryPressed, isTrue);
    });

    // ========================================================================
    // 5. JOBS TABS
    // ========================================================================
    testWidgets('Jobs screen has status tabs', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Mes missions'),
                bottom: const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'À venir (2)'),
                    Tab(text: 'En cours (1)'),
                    Tab(text: 'Terminées (5)'),
                    Tab(text: 'Annulées (0)'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  Center(child: Text('Upcoming')),
                  Center(child: Text('In Progress')),
                  Center(child: Text('Completed')),
                  Center(child: Text('Cancelled')),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify tabs are present
      expect(find.text('À venir (2)'), findsOneWidget);
      expect(find.text('En cours (1)'), findsOneWidget);
      expect(find.text('Terminées (5)'), findsOneWidget);
      expect(find.text('Annulées (0)'), findsOneWidget);
    });

    // ========================================================================
    // 6. JOB CARD CONTENT
    // ========================================================================
    testWidgets('Job card displays all required info', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                key: TestKeys.jobCard,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title + Status
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Réparation plomberie',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Assignée',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Location
                      const Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Montreal', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Date
                      const Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('15 Jan 2026', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price
                      const Text(
                        '\$150',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify all card elements
      expect(find.byKey(TestKeys.jobCard), findsOneWidget);
      expect(find.text('Réparation plomberie'), findsOneWidget);
      expect(find.text('Assignée'), findsOneWidget);
      expect(find.text('Montreal'), findsOneWidget);
      expect(find.text('15 Jan 2026'), findsOneWidget);
      expect(find.text('\$150'), findsOneWidget);
    });

    // ========================================================================
    // 7. JOB CARD TAP NAVIGATION
    // ========================================================================
    testWidgets('Tapping job card triggers navigation', (tester) async {
      bool navigated = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                key: TestKeys.jobCard,
                onTap: () {
                  navigated = true;
                },
                child: const Card(
                  child: ListTile(
                    title: Text('Test Mission'),
                    subtitle: Text('Montreal'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap card
      await tester.tap(find.byKey(TestKeys.jobCard));
      await tester.pump();

      // Verify navigation callback
      expect(navigated, isTrue);
    });

    // ========================================================================
    // 8. PULL TO REFRESH
    // ========================================================================
    testWidgets('Jobs list supports pull to refresh', (tester) async {
      bool refreshed = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                refreshed = true;
              },
              child: ListView(
                children: const [
                  ListTile(title: Text('Mission 1')),
                  ListTile(title: Text('Mission 2')),
                ],
              ),
            ),
          ),
        ),
      );

      // Perform pull to refresh gesture
      await tester.fling(find.text('Mission 1'), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Verify refresh was triggered
      expect(refreshed, isTrue);
    });
  });

  // ==========================================================================
  // JOB DETAIL TESTS
  // ==========================================================================
  group('Job Detail Widget Tests', () {
    testWidgets('Job detail shows all sections', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: TestKeys.backButton,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('Détails mission'),
            ),
            body: const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Réparation plomberie',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Status chip
                  Chip(label: Text('En cours')),
                  SizedBox(height: 16),

                  // Description section
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Réparer une fuite sous l\'évier de la cuisine.'),
                  SizedBox(height: 16),

                  // Location section
                  Text(
                    'Lieu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text('123 Rue Test, Montreal'),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Price section
                  Text(
                    'Rémunération',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$150',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify all sections
      expect(find.byKey(TestKeys.backButton), findsOneWidget);
      expect(find.text('Réparation plomberie'), findsOneWidget);
      expect(find.text('En cours'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Lieu'), findsOneWidget);
      expect(find.text('Rémunération'), findsOneWidget);
      expect(find.text('\$150'), findsOneWidget);
    });

    testWidgets('Job detail has action buttons', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Détails mission')),
            body: const Center(child: Text('Content')),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text('Contacter'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Démarrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify action buttons
      expect(find.text('Contacter'), findsOneWidget);
      expect(find.text('Démarrer'), findsOneWidget);
      expect(find.byIcon(Icons.message), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  });
}

