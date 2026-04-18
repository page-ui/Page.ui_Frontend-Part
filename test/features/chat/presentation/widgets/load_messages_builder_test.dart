import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/load_messages_builder.dart';

void main() {
  testWidgets(
    'LoadMessagesBuilder sorts messages and renders AI_RUN as assistant text',
    (WidgetTester tester) async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right([
                MessageEntity(
                  id: 'ai-run',
                  chatId: chatId,
                  senderId: '00000000-0000-0000-0000-000000000001',
                  content:
                      '/runs/75f377fc-2cae-4719-ab95-ff674a5f1784/preview.html',
                  type: 'AI_RUN',
                  status: 'sent',
                  createdAt: DateTime.parse('2026-04-18T08:02:28.677Z'),
                ),
                MessageEntity(
                  id: 'user-message',
                  chatId: chatId,
                  senderId: 'user-1',
                  content: 'test',
                  type: 'TEXT',
                  status: 'sent',
                  createdAt: DateTime.parse('2026-04-18T08:02:28.109Z'),
                ),
              ]);
            },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BlocProvider(
                create: (_) =>
                    ChatMessagesCubit(chatRepo: repo)
                      ..loadMessages(chatId: 'chat-1'),
                child: const Column(children: [LoadMessagesBuilder()]),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
      expect(find.text('AI_RUN'), findsOneWidget);
      expect(
        find.text('/runs/75f377fc-2cae-4719-ab95-ff674a5f1784/preview.html'),
        findsNothing,
      );

      final userMessageY = tester.getTopLeft(find.text('test')).dy;
      final aiRunMessageY = tester.getTopLeft(find.text('AI_RUN')).dy;
      expect(userMessageY, lessThan(aiRunMessageY));

      final aiRunAlignments = tester.widgetList<Align>(
        find.ancestor(of: find.text('AI_RUN'), matching: find.byType(Align)),
      );
      expect(
        aiRunAlignments.any(
          (widget) => widget.alignment == Alignment.centerLeft,
        ),
        isTrue,
      );
    },
  );
}

class _FakeChatRepo implements ChatRepo {
  _FakeChatRepo({required this.getMessagesHandler});

  final Future<Either<Failure, List<MessageEntity>>> Function({
    required String chatId,
    required int first,
    String? after,
  })
  getMessagesHandler;

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String chatId,
    required int first,
    String? after,
  }) => getMessagesHandler(chatId: chatId, first: first, after: after);

  @override
  Future<Either<Failure, ChatEntity>> createChat({
    required CreateChatParams params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<
    Either<
      Failure,
      ({List<ChatEntity> chats, bool hasNextPage, String? endCursor})
    >
  >
  getChats({required int first, String? after}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> searchChats({
    required String name,
    required int first,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required SendMessageParams params,
  }) {
    throw UnimplementedError();
  }
}
