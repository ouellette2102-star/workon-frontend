/// PR-T4: Message Models Unit Tests
///
/// Tests JSON parsing for conversations and messages.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:work_on_v1/services/messages/message_models.dart';

void main() {
  group('Message.fromJson', () {
    test('parses complete JSON payload', () {
      final json = {
        'id': 'msg-123',
        'missionId': 'mission-1',
        'content': 'Bonjour !',
        'senderId': 'user-1',
        'createdAt': '2026-01-15T10:30:00Z',
        'read': true,
      };

      final message = Message.fromJson(json);

      expect(message.id, 'msg-123');
      expect(message.conversationId, 'mission-1');
      expect(message.text, 'Bonjour !');
      expect(message.senderId, 'user-1');
      expect(message.isRead, true);
      expect(message.createdAt.year, 2026);
    });

    test('parses minimal JSON with defaults', () {
      final json = <String, dynamic>{};

      final message = Message.fromJson(json);

      expect(message.id, '');
      expect(message.conversationId, '');
      expect(message.text, '');
      expect(message.senderId, '');
      expect(message.isRead, false);
    });

    test('handles read/isRead field variations', () {
      // Boolean true via read
      final json1 = {'read': true};
      expect(Message.fromJson(json1).isRead, true);

      // Boolean true via isRead
      final json2 = {'isRead': true};
      expect(Message.fromJson(json2).isRead, true);

      // Boolean false
      final json3 = {'read': false};
      expect(Message.fromJson(json3).isRead, false);
    });

    test('handles text/content field variations', () {
      // Via text
      final json1 = {'text': 'Hello'};
      expect(Message.fromJson(json1).text, 'Hello');

      // Via content
      final json2 = {'content': 'Hi'};
      expect(Message.fromJson(json2).text, 'Hi');

      // Via message
      final json3 = {'message': 'Hey'};
      expect(Message.fromJson(json3).text, 'Hey');
    });

    test('handles conversationId/missionId variations', () {
      // Via missionId
      final json1 = {'missionId': 'mission-1'};
      expect(Message.fromJson(json1).conversationId, 'mission-1');

      // Via conversationId
      final json2 = {'conversationId': 'conv-1'};
      expect(Message.fromJson(json2).conversationId, 'conv-1');
    });
  });

  group('Conversation.fromJson', () {
    test('parses flat JSON payload', () {
      final json = {
        'id': 'conv-1',
        'missionId': 'mission-123',
        'missionTitle': 'Réparation plomberie',
        'otherUserId': 'user-2',
        'otherUserName': 'Jean Dupont',
        'lastMessage': 'Merci !',
        'lastMessageAt': '2026-01-15T14:30:00Z',
        'unreadCount': 3,
      };

      final conversation = Conversation.fromJson(json);

      expect(conversation.id, 'conv-1');
      expect(conversation.missionId, 'mission-123');
      expect(conversation.missionTitle, 'Réparation plomberie');
      expect(conversation.participantId, 'user-2');
      expect(conversation.participantName, 'Jean Dupont');
      expect(conversation.lastMessage, 'Merci !');
      expect(conversation.unreadCount, 3);
    });

    test('parses nested participant JSON', () {
      final json = {
        'id': 'conv-1',
        'participant': {
          'id': 'user-2',
          'fullName': 'Jean Dupont',
          'avatar': 'https://example.com/photo.jpg',
        },
        'mission': {
          'id': 'mission-1',
          'title': 'Test Mission',
        },
        'lastMessage': 'Hello',
        'unreadCount': 1,
      };

      final conversation = Conversation.fromJson(json);

      expect(conversation.participantId, 'user-2');
      expect(conversation.participantName, 'Jean Dupont');
      expect(conversation.participantAvatar, 'https://example.com/photo.jpg');
      expect(conversation.missionId, 'mission-1');
      expect(conversation.missionTitle, 'Test Mission');
    });

    test('parses minimal JSON with defaults', () {
      final json = <String, dynamic>{};

      final conversation = Conversation.fromJson(json);

      expect(conversation.id, '');
      expect(conversation.participantId, '');
      expect(conversation.participantName, 'Utilisateur');
      expect(conversation.participantAvatar, isNull);
      expect(conversation.lastMessage, isNull);
      expect(conversation.unreadCount, 0);
    });

    test('handles unreadCount as int', () {
      final json = {
        'id': 'conv-1',
        'unreadCount': 5,
      };

      final conversation = Conversation.fromJson(json);
      expect(conversation.unreadCount, 5);
    });
  });

  group('Conversation initials', () {
    test('returns initials from two-word name', () {
      final conv = Conversation(
        id: '1',
        participantId: 'user-1',
        participantName: 'Jean Dupont',
      );
      expect(conv.initials, 'JD');
    });

    test('returns initial from single name', () {
      final conv = Conversation(
        id: '1',
        participantId: 'user-1',
        participantName: 'Jean',
      );
      expect(conv.initials, 'J');
    });
  });

  group('Message comparison and sorting', () {
    test('messages can be compared by date', () {
      final older = Message(
        id: 'msg-1',
        conversationId: 'conv-1',
        senderId: 'user-1',
        text: 'Old',
        createdAt: DateTime(2026, 1, 15, 10, 0),
      );

      final newer = Message(
        id: 'msg-2',
        conversationId: 'conv-1',
        senderId: 'user-1',
        text: 'New',
        createdAt: DateTime(2026, 1, 15, 12, 0),
      );

      expect(older.createdAt.isBefore(newer.createdAt), true);
    });
  });

  group('Message.optimistic', () {
    test('creates optimistic message for UI', () {
      final msg = Message.optimistic(
        conversationId: 'conv-1',
        senderId: 'user-1',
        text: 'Sending...',
      );

      expect(msg.id, startsWith('temp_'));
      expect(msg.conversationId, 'conv-1');
      expect(msg.senderId, 'user-1');
      expect(msg.text, 'Sending...');
      expect(msg.isSending, true);
    });
  });

  group('Message.copyWith', () {
    test('creates copy with updated fields', () {
      final original = Message(
        id: 'temp_123',
        conversationId: 'conv-1',
        senderId: 'user-1',
        text: 'Hello',
        createdAt: DateTime.now(),
        isSending: true,
      );

      final updated = original.copyWith(id: 'msg-real', isSending: false);

      expect(updated.id, 'msg-real');
      expect(updated.isSending, false);
      expect(updated.text, 'Hello'); // unchanged
    });
  });
}

