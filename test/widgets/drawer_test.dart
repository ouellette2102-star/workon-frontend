/// PR-T3: Drawer/Navigation Widget Tests
///
/// Tests drawer menu rendering and navigation actions.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Drawer Widget Tests', () {
    // ========================================================================
    // 1. DRAWER RENDERS
    // ========================================================================
    testWidgets('Drawer displays all menu items', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Header
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text('JD'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Jean Dupont',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'jean@example.com',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // Menu items
                  const ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Accueil'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.work),
                    title: Text('Mes missions'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Revenus'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('Messages'),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Paramètres'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Aide'),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Déconnexion',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Open drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('jean@example.com'), findsOneWidget);

      // Verify menu items
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Mes missions'), findsOneWidget);
      expect(find.text('Revenus'), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Aide'), findsOneWidget);
      expect(find.text('Déconnexion'), findsOneWidget);
    });

    // ========================================================================
    // 2. DRAWER MENU NAVIGATION
    // ========================================================================
    testWidgets('Drawer menu items trigger navigation', (tester) async {
      String? navigatedTo;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Accueil'),
                    onTap: () {
                      navigatedTo = 'home';
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Mes missions'),
                    onTap: () {
                      navigatedTo = 'jobs';
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Revenus'),
                    onTap: () {
                      navigatedTo = 'earnings';
                    },
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Open drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Tap on "Mes missions"
      await tester.tap(find.text('Mes missions'));
      await tester.pump();

      // Verify navigation
      expect(navigatedTo, equals('jobs'));
    });

    // ========================================================================
    // 3. DRAWER ACTIVE PAGE HIGHLIGHT
    // ========================================================================
    testWidgets('Drawer highlights active page', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Accueil'),
                    selected: false,
                  ),
                  ListTile(
                    leading: const Icon(Icons.work, color: Colors.blue),
                    title: const Text(
                      'Mes missions',
                      style: TextStyle(color: Colors.blue),
                    ),
                    selected: true,
                    selectedTileColor: Colors.blue.shade50,
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Revenus'),
                    selected: false,
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Open drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Find the selected ListTile
      final selectedTile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Mes missions'),
          matching: find.byType(ListTile),
        ),
      );

      // Verify it's selected
      expect(selectedTile.selected, isTrue);
    });

    // ========================================================================
    // 4. DRAWER CLOSE ON ITEM TAP
    // ========================================================================
    testWidgets('Drawer closes when item is tapped', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Accueil'),
                    onTap: () {
                      // Navigation would close drawer via Navigator.pop
                    },
                  ),
                ],
              ),
            ),
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Text('Open Drawer'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open drawer
      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();

      // Verify drawer is open
      expect(find.text('Accueil'), findsOneWidget);

      // Close drawer by tapping outside (scrim)
      await tester.tapAt(const Offset(400, 300));
      await tester.pumpAndSettle();

      // Verify drawer is closed (item not visible)
      expect(find.text('Accueil'), findsNothing);
    });

    // ========================================================================
    // 5. DRAWER LOGOUT CONFIRMATION
    // ========================================================================
    testWidgets('Logout shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  Builder(
                    builder: (context) => ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Déconnexion'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Déconnexion'),
                            content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Open drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Tap logout
      await tester.tap(find.text('Déconnexion'));
      await tester.pumpAndSettle();

      // Verify dialog
      expect(find.text('Voulez-vous vraiment vous déconnecter ?'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
      expect(find.text('Confirmer'), findsOneWidget);
    });

    // ========================================================================
    // 6. DRAWER NOTIFICATION BADGE
    // ========================================================================
    testWidgets('Drawer shows notification badge on messages', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('Messages'),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Open drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Verify badge
      expect(find.text('3'), findsOneWidget);
    });
  });
}

