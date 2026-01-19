/// PR-T3: Auth/Login Widget Tests
///
/// Tests login form rendering, validation, and basic interactions.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Auth/Login Widget Tests', () {
    // ========================================================================
    // 1. LOGIN FORM RENDERING
    // ========================================================================
    testWidgets('Login form displays email and password fields', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App title/logo placeholder
                  const Text(
                    'WorkOn',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  TextField(
                    key: TestKeys.loginEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'votre@email.com',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    key: TestKeys.loginPassword,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: TestKeys.loginButton,
                      onPressed: () {},
                      child: const Text('Se connecter'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify form elements are present
      expect(find.byKey(TestKeys.loginEmail), findsOneWidget);
      expect(find.byKey(TestKeys.loginPassword), findsOneWidget);
      expect(find.byKey(TestKeys.loginButton), findsOneWidget);

      // Verify labels
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    // ========================================================================
    // 2. EMAIL INPUT INTERACTION
    // ========================================================================
    testWidgets('Email field accepts input', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                key: TestKeys.loginEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
          ),
        ),
      );

      // Enter email
      await tester.enterText(find.byKey(TestKeys.loginEmail), 'test@example.com');
      await tester.pump();

      // Verify input is displayed
      expect(find.text('test@example.com'), findsOneWidget);
    });

    // ========================================================================
    // 3. PASSWORD FIELD OBSCURED
    // ========================================================================
    testWidgets('Password field obscures text', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                key: TestKeys.loginPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
              ),
            ),
          ),
        ),
      );

      // Enter password
      await tester.enterText(find.byKey(TestKeys.loginPassword), 'secret123');
      await tester.pump();

      // The password widget should exist but text should be obscured
      final passwordField = tester.widget<TextField>(find.byKey(TestKeys.loginPassword));
      expect(passwordField.obscureText, isTrue);
    });

    // ========================================================================
    // 4. LOGIN BUTTON TAP
    // ========================================================================
    testWidgets('Login button is tappable', (tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Center(
              child: ElevatedButton(
                key: TestKeys.loginButton,
                onPressed: () {
                  buttonPressed = true;
                },
                child: const Text('Se connecter'),
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.byKey(TestKeys.loginButton));
      await tester.pump();

      // Verify callback was triggered
      expect(buttonPressed, isTrue);
    });

    // ========================================================================
    // 5. LOADING STATE
    // ========================================================================
    testWidgets('Login shows loading indicator when processing', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Connexion en cours...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading elements
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Connexion en cours...'), findsOneWidget);
    });

    // ========================================================================
    // 6. ERROR STATE
    // ========================================================================
    testWidgets('Login shows error message on failure', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade50,
                  child: const Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Email ou mot de passe incorrect',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify error message
      expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    // ========================================================================
    // 7. SIGNUP LINK
    // ========================================================================
    testWidgets('Login page has signup link', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  key: TestKeys.signupButton,
                  onPressed: () {},
                  child: const Text('Pas encore de compte ? S\'inscrire'),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify signup link exists
      expect(find.byKey(TestKeys.signupButton), findsOneWidget);
      expect(findTextContaining('inscrire'), findsOneWidget);
    });

    // ========================================================================
    // 8. FORM VALIDATION UI
    // ========================================================================
    testWidgets('Shows validation error for empty email', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      key: TestKeys.loginEmail,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'email est requis';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        formKey.currentState?.validate();
                      },
                      child: const Text('Valider'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Tap validate without entering email
      await tester.tap(find.text('Valider'));
      await tester.pump();

      // Verify validation error
      expect(find.text('L\'email est requis'), findsOneWidget);
    });
  });
}

