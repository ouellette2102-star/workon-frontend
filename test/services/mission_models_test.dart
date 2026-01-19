/// PR-T4: Mission Models Unit Tests
///
/// Tests JSON parsing, serialization, and model validation.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:work_on_v1/services/missions/mission_models.dart';

void main() {
  group('MissionStatus', () {
    test('fromString parses all valid statuses', () {
      expect(MissionStatus.fromString('open'), MissionStatus.open);
      expect(MissionStatus.fromString('assigned'), MissionStatus.assigned);
      expect(MissionStatus.fromString('in_progress'), MissionStatus.inProgress);
      expect(MissionStatus.fromString('completed'), MissionStatus.completed);
      expect(MissionStatus.fromString('paid'), MissionStatus.paid);
      expect(MissionStatus.fromString('cancelled'), MissionStatus.cancelled);
    });

    test('fromString is case insensitive', () {
      expect(MissionStatus.fromString('OPEN'), MissionStatus.open);
      expect(MissionStatus.fromString('Assigned'), MissionStatus.assigned);
      expect(MissionStatus.fromString('IN_PROGRESS'), MissionStatus.inProgress);
    });

    test('fromString defaults to open for unknown status', () {
      expect(MissionStatus.fromString('unknown'), MissionStatus.open);
      expect(MissionStatus.fromString('invalid'), MissionStatus.open);
      expect(MissionStatus.fromString(''), MissionStatus.open);
    });

    test('displayName returns French labels', () {
      expect(MissionStatus.open.displayName, 'Disponible');
      expect(MissionStatus.assigned.displayName, 'Assignée');
      expect(MissionStatus.inProgress.displayName, 'En cours');
      expect(MissionStatus.completed.displayName, 'Terminée');
      expect(MissionStatus.paid.displayName, 'Payée');
      expect(MissionStatus.cancelled.displayName, 'Annulée');
    });
  });

  group('Mission.fromJson', () {
    test('parses complete JSON payload', () {
      final json = {
        'id': 'mission-123',
        'title': 'Réparation plomberie',
        'description': 'Fuite sous évier',
        'category': 'plumbing',
        'status': 'open',
        'price': 150.0,
        'latitude': 45.5017,
        'longitude': -73.5673,
        'city': 'Montreal',
        'address': '123 Rue Test',
        'createdByUserId': 'user-1',
        'assignedToUserId': 'user-2',
        'distanceKm': 2.5,
        'createdAt': '2026-01-15T10:00:00Z',
        'updatedAt': '2026-01-15T12:00:00Z',
      };

      final mission = Mission.fromJson(json);

      expect(mission.id, 'mission-123');
      expect(mission.title, 'Réparation plomberie');
      expect(mission.description, 'Fuite sous évier');
      expect(mission.category, 'plumbing');
      expect(mission.status, MissionStatus.open);
      expect(mission.price, 150.0);
      expect(mission.latitude, 45.5017);
      expect(mission.longitude, -73.5673);
      expect(mission.city, 'Montreal');
      expect(mission.address, '123 Rue Test');
      expect(mission.createdByUserId, 'user-1');
      expect(mission.assignedToUserId, 'user-2');
      expect(mission.distanceKm, 2.5);
    });

    test('parses minimal JSON with defaults', () {
      final json = <String, dynamic>{};

      final mission = Mission.fromJson(json);

      expect(mission.id, '');
      expect(mission.title, '');
      expect(mission.description, '');
      expect(mission.category, '');
      expect(mission.status, MissionStatus.open);
      expect(mission.price, 0.0);
      expect(mission.latitude, 0.0);
      expect(mission.longitude, 0.0);
      expect(mission.city, '');
      expect(mission.address, isNull);
      expect(mission.createdByUserId, '');
      expect(mission.assignedToUserId, isNull);
      expect(mission.distanceKm, isNull);
    });

    test('handles int price as double', () {
      final json = {
        'id': 'mission-1',
        'price': 100, // int, not double
        'createdAt': '2026-01-15T10:00:00Z',
        'updatedAt': '2026-01-15T10:00:00Z',
      };

      final mission = Mission.fromJson(json);
      expect(mission.price, 100.0);
    });

    test('handles null optional fields', () {
      final json = {
        'id': 'mission-1',
        'address': null,
        'assignedToUserId': null,
        'distanceKm': null,
        'createdAt': '2026-01-15T10:00:00Z',
        'updatedAt': '2026-01-15T10:00:00Z',
      };

      final mission = Mission.fromJson(json);
      expect(mission.address, isNull);
      expect(mission.assignedToUserId, isNull);
      expect(mission.distanceKm, isNull);
    });

    test('parses ISO 8601 dates', () {
      final json = {
        'id': 'mission-1',
        'createdAt': '2026-01-15T10:30:00.000Z',
        'updatedAt': '2026-01-15T14:45:00.000Z',
      };

      final mission = Mission.fromJson(json);
      expect(mission.createdAt.year, 2026);
      expect(mission.createdAt.month, 1);
      expect(mission.createdAt.day, 15);
    });
  });

  group('Mission.toJson', () {
    test('serializes complete mission', () {
      final mission = Mission(
        id: 'mission-123',
        title: 'Test',
        description: 'Desc',
        category: 'cat',
        status: MissionStatus.inProgress,
        price: 100.0,
        latitude: 45.5,
        longitude: -73.5,
        city: 'Montreal',
        address: '123 St',
        createdByUserId: 'user-1',
        assignedToUserId: 'user-2',
        distanceKm: 5.0,
        createdAt: DateTime(2026, 1, 15, 10, 0),
        updatedAt: DateTime(2026, 1, 15, 12, 0),
      );

      final json = mission.toJson();

      expect(json['id'], 'mission-123');
      expect(json['title'], 'Test');
      expect(json['status'], 'inProgress');
      expect(json['price'], 100.0);
      expect(json['address'], '123 St');
      expect(json['assignedToUserId'], 'user-2');
      expect(json['distanceKm'], 5.0);
    });

    test('serializes null optional fields', () {
      final mission = Mission(
        id: 'mission-1',
        title: 'Test',
        description: '',
        category: '',
        status: MissionStatus.open,
        price: 0,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = mission.toJson();
      expect(json['address'], isNull);
      expect(json['assignedToUserId'], isNull);
      expect(json['distanceKm'], isNull);
    });
  });

  group('Mission formatting', () {
    test('formattedPrice returns dollar format', () {
      final mission = Mission(
        id: '1',
        title: '',
        description: '',
        category: '',
        status: MissionStatus.open,
        price: 150.50,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(mission.formattedPrice, '\$150.50');
    });

    test('formattedDistance handles kilometers', () {
      final mission = Mission(
        id: '1',
        title: '',
        description: '',
        category: '',
        status: MissionStatus.open,
        price: 0,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        distanceKm: 2.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(mission.formattedDistance, '2.5 km');
    });

    test('formattedDistance handles meters', () {
      final mission = Mission(
        id: '1',
        title: '',
        description: '',
        category: '',
        status: MissionStatus.open,
        price: 0,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        distanceKm: 0.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(mission.formattedDistance, '500 m');
    });

    test('formattedDistance returns null when no distance', () {
      final mission = Mission(
        id: '1',
        title: '',
        description: '',
        category: '',
        status: MissionStatus.open,
        price: 0,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(mission.formattedDistance, isNull);
    });
  });

  group('Mission toString', () {
    test('returns readable string', () {
      final mission = Mission(
        id: 'mission-123',
        title: 'Test Mission',
        description: '',
        category: '',
        status: MissionStatus.inProgress,
        price: 0,
        latitude: 0,
        longitude: 0,
        city: '',
        createdByUserId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(mission.toString(), 'Mission(mission-123, Test Mission, MissionStatus.inProgress)');
    });
  });
}

