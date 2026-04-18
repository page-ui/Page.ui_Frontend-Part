import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
    'LoadMessagesBuilder renders realtime AI_RUN messages with full localhost URLs',
    (WidgetTester tester) async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  MessageEntity(
                    id: 'user-message',
                    chatId: chatId,
                    senderId: 'user-1',
                    content: 'test',
                    type: 'TEXT',
                    status: 'sent',
                    createdAt: DateTime.parse('2026-04-18T08:02:28.109Z'),
                  ),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: BlocProvider(
                create: (_) =>
                    ChatMessagesCubit(chatRepo: repo)
                      ..openChat(chatId: 'chat-1'),
                child: const Column(children: [LoadMessagesBuilder()]),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      controller.add(
        MessageEntity(
          id: 'ai-run',
          chatId: 'chat-1',
          senderId: '00000000-0000-0000-0000-000000000001',
          content: '/runs/75f377fc-2cae-4719-ab95-ff674a5f1784/preview.html',
          type: 'AI_RUN',
          status: 'sent',
          createdAt: DateTime.parse('2026-04-18T08:02:28.677Z'),
        ),
      );

      await tester.pumpAndSettle();

      const fullUrl =
          'http://localhost/runs/75f377fc-2cae-4719-ab95-ff674a5f1784/preview.html';

      expect(find.text('test'), findsOneWidget);
      expect(find.text(fullUrl), findsOneWidget);

      final userMessageY = tester.getTopLeft(find.text('test')).dy;
      final aiRunMessageY = tester.getTopLeft(find.text(fullUrl)).dy;
      expect(userMessageY, lessThan(aiRunMessageY));

      final aiRunAlignments = tester.widgetList<Align>(
        find.ancestor(of: find.text(fullUrl), matching: find.byType(Align)),
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
  _FakeChatRepo({
    required this.getMessagesHandler,
    Stream<MessageEntity> Function({required String chatId})?
    subscribeToMessagesHandler,
  }) : _subscribeToMessagesHandler =
           subscribeToMessagesHandler ??
           (({required chatId}) => const Stream.empty());

  final Future<
    Either<
      Failure,
      ({List<MessageEntity> messages, bool hasNextPage, String? endCursor})
    >
  >
  Function({
    required String chatId,
    required int first,
    String? after,
  })
  getMessagesHandler;
  final Stream<MessageEntity> Function({required String chatId})
  _subscribeToMessagesHandler;

  @override
  Future<
    Either<
      Failure,
      ({List<MessageEntity> messages, bool hasNextPage, String? endCursor})
    >
  >
  getMessages({
    required String chatId,
    required int first,
    String? after,
  }) => getMessagesHandler(chatId: chatId, first: first, after: after);

  @override
  Stream<MessageEntity> subscribeToMessages({required String chatId}) {
    return _subscribeToMessagesHandler(chatId: chatId);
  }

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
