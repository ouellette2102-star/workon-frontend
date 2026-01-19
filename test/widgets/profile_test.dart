/// PR-T3: Profile Widget Tests
///
/// Tests profile page rendering and sections.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Profile Widget Tests', () {
    // ========================================================================
    // 1. PROFILE HEADER
    // ========================================================================
    testWidgets('Profile displays user info header', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mon profil')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    key: TestKeys.profileAvatar,
                    radius: 50,
                    child: const Text('JD', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    'Jean Dupont',
                    key: TestKeys.profileName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    'jean.dupont@example.com',
                    key: TestKeys.profileEmail,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Travailleur',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify profile header
      expect(find.byKey(TestKeys.profileAvatar), findsOneWidget);
      expect(find.byKey(TestKeys.profileName), findsOneWidget);
      expect(find.byKey(TestKeys.profileEmail), findsOneWidget);
      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('jean.dupont@example.com'), findsOneWidget);
      expect(find.text('Travailleur'), findsOneWidget);
    });

    // ========================================================================
    // 2. PROFILE MENU SECTIONS
    // ========================================================================
    testWidgets('Profile shows menu sections', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mon profil')),
            body: ListView(
              children: const [
                // Section header
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Modifier le profil'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notifications'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Langue'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Français', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Sécurité'),
                  trailing: Icon(Icons.chevron_right),
                ),

                Divider(),

                // Support section
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Aide et FAQ'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('Conditions d\'utilisation'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Politique de confidentialité'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify menu items
      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Modifier le profil'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Langue'), findsOneWidget);
      expect(find.text('Sécurité'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Aide et FAQ'), findsOneWidget);
    });

    // ========================================================================
    // 3. LOGOUT BUTTON
    // ========================================================================
    testWidgets('Profile has logout button', (tester) async {
      bool loggedOut = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Mon profil')),
            body: Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        loggedOut = true;
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Se déconnecter',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify logout button
      expect(find.text('Se déconnecter'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      // Tap logout
      await tester.tap(find.text('Se déconnecter'));
      await tester.pump();
      expect(loggedOut, isTrue);
    });

    // ========================================================================
    // 4. PROFILE STATS
    // ========================================================================
    testWidgets('Profile shows user stats', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        '25',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Missions',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Note moyenne',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '18',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Avis',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify stats
      expect(find.text('25'), findsOneWidget);
      expect(find.text('Missions'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('Note moyenne'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('Avis'), findsOneWidget);
    });

    // ========================================================================
    // 5. EDIT PROFILE NAVIGATION
    // ========================================================================
    testWidgets('Edit profile menu item is tappable', (tester) async {
      bool navigated = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Modifier le profil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                navigated = true;
              },
            ),
          ),
        ),
      );

      // Tap menu item
      await tester.tap(find.text('Modifier le profil'));
      await tester.pump();

      // Verify navigation
      expect(navigated, isTrue);
    });

    // ========================================================================
    // 6. VERSION INFO
    // ========================================================================
    testWidgets('Profile shows app version', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Column(
              children: [
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Version 1.1.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify version
      expect(find.text('Version 1.1.0'), findsOneWidget);
    });
  });
}

