import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

void main() {
  group('SendMessageParams.toInputJson', () {
    test('escapes multiline content when there is no attachment', () {
      final params = SendMessageParams(
        chatId: 'chat-1',
        content: 'line1\r\nline2',
      );

      final input = params.toInputJson();

      expect(input['content'], 'line1\\nline2');
      expect(input.containsKey('attachmentUrl'), isFalse);
    });

    test('escapes multiline content when attachment is present', () {
      final params = SendMessageParams(
        chatId: 'chat-1',
        content: 'line1\r\nline2\nline3',
        attachmentUrl: 'https://cdn.example/file.png',
      );

      final input = params.toInputJson();

      expect(input['content'], 'line1\\nline2\\nline3');
      expect(input['attachmentUrl'], 'https://cdn.example/file.png');
    });
  });

  group('CreateChatParams.toInputJson', () {
    test('escapes multiline content when there is no attachment', () {
      final params = CreateChatParams(name: 'chat', content: 'line1\r\nline2');

      final input = params.toInputJson();
      final initialUserMessage =
          input['initialUserMessage'] as Map<String, dynamic>;

      expect(initialUserMessage['content'], 'line1\\nline2');
      expect(initialUserMessage.containsKey('attachmentUrl'), isFalse);
    });

    test('escapes multiline content when attachment is present', () {
      final params = CreateChatParams(
        name: 'chat',
        content: 'line1\r\nline2\nline3',
        attachmentUrl: 'https://cdn.example/file.png',
      );

      final input = params.toInputJson();
      final initialUserMessage =
          input['initialUserMessage'] as Map<String, dynamic>;

      expect(initialUserMessage['content'], 'line1\\nline2\\nline3');
      expect(
        initialUserMessage['attachmentUrl'],
        'https://cdn.example/file.png',
      );
    });
  });
}
