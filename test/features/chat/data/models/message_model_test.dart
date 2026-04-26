import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/features/chat/data/models/message_model.dart';

void main() {
  test('decodes escaped multiline content from the API', () {
    final message = MessageModel.fromJson({
      'id': 'message-1',
      'chatId': 'chat-1',
      'senderId': 'user-1',
      'content': 'line1\\nline2\\nline3',
      'type': 'AI_MESSAGE',
      'status': 'sent',
      'createdAt': '2026-04-26T19:55:16.773Z',
      'attachmentUrl': null,
      'isDeleted': false,
    });

    expect(message.content, 'line1\nline2\nline3');
  });
}
