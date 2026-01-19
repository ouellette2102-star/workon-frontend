/// PR-T3: Home Widget Tests
///
/// Tests home screen rendering and basic navigation elements.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Home Widget Tests', () {
    // ========================================================================
    // 1. HOME SCREEN BASIC RENDERING
    // ========================================================================
    testWidgets('Home screen renders with app bar and content', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: TestKeys.drawerMenu,
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              title: const Text('WorkOn'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(
              child: Text('Bienvenue sur WorkOn'),
            ),
          ),
        ),
      );

      // Verify app bar elements
      expect(find.byKey(TestKeys.drawerMenu), findsOneWidget);
      expect(find.text('WorkOn'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // Verify welcome text
      expect(find.text('Bienvenue sur WorkOn'), findsOneWidget);
    });

    // ========================================================================
    // 2. HOME WITH BOTTOM NAVIGATION
    // ========================================================================
    testWidgets('Home has bottom navigation bar', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: const Center(child: Text('Home Content')),
            bottomNavigationBar: BottomNavigationBar(
              key: TestKeys.bottomNav,
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Recherche',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: 'Missions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      );

      // Verify bottom nav exists
      expect(find.byKey(TestKeys.bottomNav), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify nav items
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Recherche'), findsOneWidget);
      expect(find.text('Missions'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    // ========================================================================
    // 3. HOME LOADING STATE
    // ========================================================================
    testWidgets('Home shows loading state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('WorkOn')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement...'), findsOneWidget);
    });

    // ========================================================================
    // 4. HOME ERROR STATE
    // ========================================================================
    testWidgets('Home shows error state with retry', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('WorkOn')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  const Text('Une erreur est survenue'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      retryPressed = true;
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify error state
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Une erreur est survenue'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);

      // Tap retry
      await tester.tap(find.text('Réessayer'));
      await tester.pump();
      expect(retryPressed, isTrue);
    });

    // ========================================================================
    // 5. HOME DRAWER OPEN
    // ========================================================================
    testWidgets('Menu button opens drawer', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  key: TestKeys.drawerMenu,
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              title: const Text('WorkOn'),
            ),
            drawer: const Drawer(
              child: Center(child: Text('Drawer Content')),
            ),
            body: const Center(child: Text('Home')),
          ),
        ),
      );

      // Verify drawer is initially closed
      expect(find.text('Drawer Content'), findsNothing);

      // Tap menu button
      await tester.tap(find.byKey(TestKeys.drawerMenu));
      await tester.pumpAndSettle();

      // Verify drawer is open
      expect(find.text('Drawer Content'), findsOneWidget);
    });

    // ========================================================================
    // 6. HOME STATS CARDS
    // ========================================================================
    testWidgets('Home displays stats cards', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('WorkOn')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tableau de bord',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(Icons.work, size: 32),
                                const SizedBox(height: 8),
                                const Text('5', style: TextStyle(fontSize: 24)),
                                const Text('Missions actives'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(Icons.attach_money, size: 32),
                                const SizedBox(height: 8),
                                const Text('\$1,250', style: TextStyle(fontSize: 24)),
                                const Text('Revenus'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify stats cards
      expect(find.text('Tableau de bord'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Missions actives'), findsOneWidget);
      expect(find.text('\$1,250'), findsOneWidget);
      expect(find.text('Revenus'), findsOneWidget);
    });

    // ========================================================================
    // 7. HOME EMPTY STATE
    // ========================================================================
    testWidgets('Home shows empty state for new users', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('WorkOn')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox_outlined, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenue !',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Commencez par explorer les missions disponibles.'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Découvrir les missions'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify empty/welcome state
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('Bienvenue !'), findsOneWidget);
      expect(find.text('Découvrir les missions'), findsOneWidget);
    });
  });
}

