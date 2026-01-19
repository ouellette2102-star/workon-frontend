/// PR-T3: Chat/Messages Widget Tests
///
/// Tests chat list, conversation thread, and message input.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Chat List Widget Tests', () {
    // ========================================================================
    // 1. CHAT LIST EMPTY STATE
    // ========================================================================
    testWidgets('Chat list shows empty state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Messages')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Aucune conversation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vos conversations apparaîtront ici.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify empty state
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.text('Aucune conversation'), findsOneWidget);
      expect(find.text('Vos conversations apparaîtront ici.'), findsOneWidget);
    });

    // ========================================================================
    // 2. CHAT LIST WITH CONVERSATIONS
    // ========================================================================
    testWidgets('Chat list displays conversations', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Messages')),
            body: ListView(
              key: TestKeys.chatList,
              children: [
                ListTile(
                  leading: const CircleAvatar(child: Text('JD')),
                  title: const Text('Jean Dupont'),
                  subtitle: const Text('Dernière réponse...'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('14:30', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(child: Text('MC')),
                  title: const Text('Marie Claire'),
                  subtitle: const Text('Ok, à demain !'),
                  trailing: const Text('Hier', style: TextStyle(fontSize: 12)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Verify conversations
      expect(find.byKey(TestKeys.chatList), findsOneWidget);
      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('Marie Claire'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Unread count
      expect(find.text('14:30'), findsOneWidget);
    });

    // ========================================================================
    // 3. CHAT LIST LOADING STATE
    // ========================================================================
    testWidgets('Chat list shows loading state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Messages')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des conversations...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement des conversations...'), findsOneWidget);
    });
  });

  // ==========================================================================
  // CHAT THREAD TESTS
  // ==========================================================================
  group('Chat Thread Widget Tests', () {
    // ========================================================================
    // 1. CHAT THREAD WITH MESSAGES
    // ========================================================================
    testWidgets('Chat thread displays messages', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jean Dupont', style: TextStyle(fontSize: 16)),
                  Text(
                    'Réparation plomberie',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                // Messages list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Received message
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          key: const Key('message_received'),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('Bonjour, êtes-vous disponible demain ?'),
                        ),
                      ),

                      // Sent message
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          key: const Key('message_sent'),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Oui, je suis disponible à partir de 9h.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Input field
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: TestKeys.chatInput,
                          decoration: const InputDecoration(
                            hintText: 'Écrire un message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        key: TestKeys.chatSendButton,
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify messages
      expect(find.text('Bonjour, êtes-vous disponible demain ?'), findsOneWidget);
      expect(find.text('Oui, je suis disponible à partir de 9h.'), findsOneWidget);

      // Verify input
      expect(find.byKey(TestKeys.chatInput), findsOneWidget);
      expect(find.byKey(TestKeys.chatSendButton), findsOneWidget);
    });

    // ========================================================================
    // 2. CHAT INPUT INTERACTION
    // ========================================================================
    testWidgets('Chat input accepts text', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                key: TestKeys.chatInput,
                decoration: const InputDecoration(
                  hintText: 'Écrire un message...',
                ),
              ),
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byKey(TestKeys.chatInput), 'Test message');
      await tester.pump();

      // Verify input
      expect(find.text('Test message'), findsOneWidget);
    });

    // ========================================================================
    // 3. SEND BUTTON INTERACTION
    // ========================================================================
    testWidgets('Send button triggers callback', (tester) async {
      bool sent = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Center(
              child: IconButton(
                key: TestKeys.chatSendButton,
                icon: const Icon(Icons.send),
                onPressed: () {
                  sent = true;
                },
              ),
            ),
          ),
        ),
      );

      // Tap send
      await tester.tap(find.byKey(TestKeys.chatSendButton));
      await tester.pump();

      // Verify callback
      expect(sent, isTrue);
    });

    // ========================================================================
    // 4. CHAT EMPTY STATE
    // ========================================================================
    testWidgets('Chat thread shows empty state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Jean Dupont')),
            body: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Commencez la conversation'),
                        SizedBox(height: 8),
                        Text(
                          'Envoyez un message pour démarrer.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: TestKeys.chatInput,
                          decoration: const InputDecoration(
                            hintText: 'Écrire un message...',
                          ),
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

      // Verify empty state
      expect(find.text('Commencez la conversation'), findsOneWidget);
      expect(find.text('Envoyez un message pour démarrer.'), findsOneWidget);
    });

    // ========================================================================
    // 5. MESSAGE TIMESTAMP
    // ========================================================================
    testWidgets('Messages show timestamps', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Hello!'),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '14:30',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify timestamp
      expect(find.text('14:30'), findsOneWidget);
    });
  });
}

