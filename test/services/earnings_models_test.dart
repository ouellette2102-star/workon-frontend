/// PR-T4: Earnings Models Unit Tests
///
/// Tests JSON parsing for earnings summary and transactions.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:work_on_v1/services/earnings/earnings_models.dart';

void main() {
  group('EarningStatus', () {
    test('fromString parses all valid statuses', () {
      expect(EarningStatus.fromString('pending'), EarningStatus.pending);
      expect(EarningStatus.fromString('available'), EarningStatus.available);
      expect(EarningStatus.fromString('paid'), EarningStatus.paid);
    });

    test('fromString is case insensitive', () {
      expect(EarningStatus.fromString('PENDING'), EarningStatus.pending);
      expect(EarningStatus.fromString('Available'), EarningStatus.available);
      expect(EarningStatus.fromString('PAID'), EarningStatus.paid);
    });

    test('fromString defaults to pending for unknown', () {
      expect(EarningStatus.fromString('unknown'), EarningStatus.pending);
      expect(EarningStatus.fromString(''), EarningStatus.pending);
    });

    test('displayName returns French labels', () {
      expect(EarningStatus.pending.displayName, 'En attente');
      expect(EarningStatus.available.displayName, 'Disponible');
      expect(EarningStatus.paid.displayName, 'Payé');
    });
  });

  group('EarningsSummary.fromJson', () {
    test('parses complete JSON payload', () {
      final json = {
        'totalLifetimeGross': 1150.0,
        'totalLifetimeNet': 1000.0,
        'totalAvailable': 500.0,
        'totalPending': 200.0,
        'totalPaid': 300.0,
        'completedMissionsCount': 10,
        'paidMissionsCount': 8,
        'commissionRate': 0.15,
        'currency': 'CAD',
      };

      final summary = EarningsSummary.fromJson(json);

      expect(summary.totalLifetimeGross, 1150.0);
      expect(summary.totalLifetimeNet, 1000.0);
      expect(summary.totalAvailable, 500.0);
      expect(summary.totalPending, 200.0);
      expect(summary.totalPaid, 300.0);
      expect(summary.completedMissionsCount, 10);
      expect(summary.paidMissionsCount, 8);
      expect(summary.commissionPercent, 15);
      expect(summary.currency, 'CAD');
    });

    test('parses minimal JSON with defaults', () {
      final json = <String, dynamic>{};

      final summary = EarningsSummary.fromJson(json);

      expect(summary.totalLifetimeGross, 0.0);
      expect(summary.totalLifetimeNet, 0.0);
      expect(summary.totalAvailable, 0.0);
      expect(summary.totalPending, 0.0);
      expect(summary.totalPaid, 0.0);
      expect(summary.completedMissionsCount, 0);
      expect(summary.paidMissionsCount, 0);
      expect(summary.commissionPercent, 15); // Default
      expect(summary.currency, 'CAD'); // Default
    });

    test('handles int values as double', () {
      final json = {
        'totalLifetimeGross': 1000, // int
        'totalLifetimeNet': 850, // int
        'commissionRate': 0.15,
      };

      final summary = EarningsSummary.fromJson(json);
      expect(summary.totalLifetimeGross, 1000.0);
      expect(summary.totalLifetimeNet, 850.0);
    });
  });

  group('EarningsSummary.empty', () {
    test('creates empty summary with zero values', () {
      final summary = EarningsSummary.empty();

      expect(summary.totalLifetimeGross, 0.0);
      expect(summary.totalLifetimeNet, 0.0);
      expect(summary.totalAvailable, 0.0);
      expect(summary.totalPending, 0.0);
      expect(summary.totalPaid, 0.0);
      expect(summary.completedMissionsCount, 0);
      expect(summary.paidMissionsCount, 0);
    });
  });

  group('EarningTransaction.fromJson', () {
    test('parses complete JSON payload', () {
      final json = {
        'id': 'tx-123',
        'missionId': 'mission-123',
        'missionTitle': 'Réparation plomberie',
        'clientName': 'Jean Dupont',
        'grossAmount': 100.0,
        'commissionAmount': 15.0,
        'netAmount': 85.0,
        'status': 'available',
        'date': '2026-01-15T10:00:00Z',
        'currency': 'CAD',
      };

      final tx = EarningTransaction.fromJson(json);

      expect(tx.id, 'tx-123');
      expect(tx.missionId, 'mission-123');
      expect(tx.missionTitle, 'Réparation plomberie');
      expect(tx.clientName, 'Jean Dupont');
      expect(tx.grossAmount, 100.0);
      expect(tx.commissionAmount, 15.0);
      expect(tx.netAmount, 85.0);
      expect(tx.status, EarningStatus.available);
      expect(tx.date.year, 2026);
      expect(tx.currency, 'CAD');
    });

    test('parses minimal JSON with defaults', () {
      final json = <String, dynamic>{};

      final tx = EarningTransaction.fromJson(json);

      expect(tx.id, '');
      expect(tx.missionId, '');
      expect(tx.missionTitle, 'Mission');
      expect(tx.clientName, 'Client');
      expect(tx.grossAmount, 0.0);
      expect(tx.commissionAmount, 0.0);
      expect(tx.netAmount, 0.0);
      expect(tx.status, EarningStatus.pending);
      expect(tx.currency, 'CAD');
    });

    test('handles int amounts as double', () {
      final json = {
        'grossAmount': 100,
        'commissionAmount': 15,
        'netAmount': 85,
      };

      final tx = EarningTransaction.fromJson(json);
      expect(tx.grossAmount, 100.0);
      expect(tx.commissionAmount, 15.0);
      expect(tx.netAmount, 85.0);
    });
  });

  group('EarningsHistoryResponse.fromJson', () {
    test('parses transactions list with pagination', () {
      final json = {
        'transactions': [
          {
            'missionId': 'mission-1',
            'missionTitle': 'Mission 1',
            'grossAmount': 100.0,
            'commissionAmount': 15.0,
            'netAmount': 85.0,
            'status': 'paid',
            'date': '2026-01-15T10:00:00Z',
          },
          {
            'missionId': 'mission-2',
            'missionTitle': 'Mission 2',
            'grossAmount': 200.0,
            'commissionAmount': 30.0,
            'netAmount': 170.0,
            'status': 'available',
            'date': '2026-01-14T10:00:00Z',
          },
        ],
        'nextCursor': 'cursor-abc',
      };

      final response = EarningsHistoryResponse.fromJson(json);

      expect(response.transactions.length, 2);
      expect(response.transactions[0].missionId, 'mission-1');
      expect(response.transactions[1].missionId, 'mission-2');
      expect(response.nextCursor, 'cursor-abc');
    });

    test('handles empty transactions list', () {
      final json = {
        'transactions': <Map<String, dynamic>>[],
        'nextCursor': null,
      };

      final response = EarningsHistoryResponse.fromJson(json);

      expect(response.transactions, isEmpty);
      expect(response.nextCursor, isNull);
    });

    test('handles missing nextCursor', () {
      final json = {
        'transactions': <Map<String, dynamic>>[],
      };

      final response = EarningsHistoryResponse.fromJson(json);
      expect(response.nextCursor, isNull);
    });

    test('handles transactions as direct list', () {
      final json = {
        'transactions': [
          {
            'missionId': 'mission-1',
            'missionTitle': 'Mission 1',
            'date': '2026-01-15T10:00:00Z',
          },
        ],
        'totalCount': 1,
      };

      final response = EarningsHistoryResponse.fromJson(json);
      expect(response.transactions.length, 1);
    });
  });
}

