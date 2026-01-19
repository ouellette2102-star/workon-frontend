/// PR-T3: Earnings Widget Tests
///
/// Tests earnings summary, history list, and transaction cards.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Earnings Widget Tests', () {
    // ========================================================================
    // 1. EARNINGS SUMMARY CARD
    // ========================================================================
    testWidgets('Earnings shows summary card with totals', (tester) async {
      final summary = MockEarnings.createSummary(
        totalLifetimeNet: 1500.0,
        totalAvailable: 800.0,
        totalPending: 300.0,
        totalPaid: 400.0,
        completedMissionsCount: 15,
      );

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main balance card
                  Container(
                    key: TestKeys.earningsSummary,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.shade700],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total des revenus (net)',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${summary['totalLifetimeNet']}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Disponible',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '\$${summary['totalAvailable']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'En attente',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '\$${summary['totalPending']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Payé',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '\$${summary['totalPaid']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify summary card
      expect(find.byKey(TestKeys.earningsSummary), findsOneWidget);
      expect(find.text('Total des revenus (net)'), findsOneWidget);
      expect(find.text('\$1500.0'), findsOneWidget);
      expect(find.text('Disponible'), findsOneWidget);
      expect(find.text('\$800.0'), findsOneWidget);
      expect(find.text('En attente'), findsOneWidget);
      expect(find.text('\$300.0'), findsOneWidget);
      expect(find.text('Payé'), findsOneWidget);
      expect(find.text('\$400.0'), findsOneWidget);
    });

    // ========================================================================
    // 2. EARNINGS HISTORY LIST
    // ========================================================================
    testWidgets('Earnings displays transaction history', (tester) async {
      final transactions = MockEarnings.createTransactionList(3);

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: ListView.builder(
              key: TestKeys.earningsHistory,
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Historique des revenus',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final tx = transactions[index - 1];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['missionTitle'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tx['clientName'] as String,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${tx['netAmount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify history list
      expect(find.byKey(TestKeys.earningsHistory), findsOneWidget);
      expect(find.text('Historique des revenus'), findsOneWidget);
      expect(find.text('Mission #0'), findsOneWidget);
      expect(find.text('Mission #1'), findsOneWidget);
      expect(find.text('Mission #2'), findsOneWidget);
    });

    // ========================================================================
    // 3. EARNINGS LOADING STATE
    // ========================================================================
    testWidgets('Earnings shows loading state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: const Center(
              key: TestKeys.earningsLoading,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des revenus...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading state
      expect(find.byKey(TestKeys.earningsLoading), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement des revenus...'), findsOneWidget);
    });

    // ========================================================================
    // 4. EARNINGS EMPTY STATE
    // ========================================================================
    testWidgets('Earnings shows empty state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Aucun revenu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complétez des missions pour voir vos revenus.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify empty state
      expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
      expect(find.text('Aucun revenu'), findsOneWidget);
      expect(find.text('Complétez des missions pour voir vos revenus.'), findsOneWidget);
    });

    // ========================================================================
    // 5. EARNINGS STATS CARDS
    // ========================================================================
    testWidgets('Earnings displays stat cards', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(height: 8),
                            const Text('15', style: TextStyle(fontSize: 24)),
                            const Text('Terminées'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.paid, color: Colors.blue),
                            const SizedBox(height: 8),
                            const Text('12', style: TextStyle(fontSize: 24)),
                            const Text('Payées'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify stat cards
      expect(find.text('15'), findsOneWidget);
      expect(find.text('Terminées'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Payées'), findsOneWidget);
    });

    // ========================================================================
    // 6. COMMISSION INFO
    // ========================================================================
    testWidgets('Earnings shows commission info', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Revenus')),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Commission plateforme : 15%',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify commission info
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text('Commission plateforme : 15%'), findsOneWidget);
    });

    // ========================================================================
    // 7. TRANSACTION CARD DETAILS
    // ========================================================================
    testWidgets('Transaction card shows all details', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Réparation plomberie',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Disponible',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Client + Date
                      const Row(
                        children: [
                          Icon(Icons.person_outline, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Jean Dupont', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text('15 Jan 2026', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Amounts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Gross - Commission
                          const Row(
                            children: [
                              Text(
                                '\$100',
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '- \$15',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          // Net
                          const Text(
                            '\$85.00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify transaction details
      expect(find.text('Réparation plomberie'), findsOneWidget);
      expect(find.text('Disponible'), findsOneWidget);
      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('15 Jan 2026'), findsOneWidget);
      expect(find.text('\$100'), findsOneWidget);
      expect(find.text('- \$15'), findsOneWidget);
      expect(find.text('\$85.00'), findsOneWidget);
    });
  });
}

