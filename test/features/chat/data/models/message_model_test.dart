import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/features/chat/data/models/message_model.dart';

void main() {
  test(
    'MessageModel.fromJson uses fallback chatId and default status when fields are missing',
    () {
      final model = MessageModel.fromJson(
        _messageNode,
        fallbackChatId: 'chat-1',
      );

      expect(model.id, 'a63e0796-cdca-4fc2-b20f-17df1437cf4e');
      expect(model.chatId, 'chat-1');
      expect(model.type, 'AI_RUN');
      expect(model.status, MessageModel.defaultStatus);
      expect(model.isDeleted, isFalse);
      expect(model.attachmentUrl, isNull);
      expect(model.createdAt, DateTime.parse('2026-04-18T08:02:28.677Z'));
    },
  );

  test(
    'MessageModel.fromJson throws when chatId is missing and no fallback is provided',
    () {
      expect(
        () => MessageModel.fromJson(_messageNode),
        throwsA(isA<FormatException>()),
      );
    },
  );
}

const Map<String, dynamic> _messageNode = {
  'id': 'a63e0796-cdca-4fc2-b20f-17df1437cf4e',
  'content': '/runs/75f377fc-2cae-4719-ab95-ff674a5f1784/preview.html',
  'senderId': '00000000-0000-0000-0000-000000000001',
  'type': 'AI_RUN',
  'createdAt': '2026-04-18T08:02:28.677Z',
  'attachmentUrl': null,
};
