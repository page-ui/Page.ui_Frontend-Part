import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';

void main() {
  test(
    'ChatMessagesCubit emits loading then loaded when messages fetch succeeds',
    () async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right([
                _message(id: 'message-1', chatId: chatId, content: 'Hello'),
              ]);
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      final emittedStates = <ChatMessagesState>[];
      final subscription = cubit.stream.listen(emittedStates.add);
      addTearDown(subscription.cancel);

      await cubit.loadMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(emittedStates.first, isA<ChatMessagesLoading>());
      expect(cubit.state, isA<ChatMessagesLoaded>());

      final loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.chatId, 'chat-1');
      expect(loadedState.messages, hasLength(1));
      expect(loadedState.messages.single.content, 'Hello');
    },
  );

  test('ChatMessagesCubit emits error when messages fetch fails', () async {
    final repo = _FakeChatRepo(
      getMessagesHandler:
          ({required chatId, required first, String? after}) async {
            return Left(ServerFailure(message: 'Failed to load messages.'));
          },
    );
    final cubit = ChatMessagesCubit(chatRepo: repo);
    addTearDown(cubit.close);

    final emittedStates = <ChatMessagesState>[];
    final subscription = cubit.stream.listen(emittedStates.add);
    addTearDown(subscription.cancel);

    await cubit.loadMessages(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    expect(emittedStates.first, isA<ChatMessagesLoading>());
    expect(cubit.state, isA<ChatMessagesError>());

    final errorState = cubit.state as ChatMessagesError;
    expect(errorState.chatId, 'chat-1');
    expect(errorState.message, 'Failed to load messages.');
  });

  test(
    'ChatMessagesCubit ignores stale results from an older in-flight request',
    () async {
      final firstCompleter = Completer<Either<Failure, List<MessageEntity>>>();
      final secondCompleter = Completer<Either<Failure, List<MessageEntity>>>();

      final repo = _FakeChatRepo(
        getMessagesHandler: ({required chatId, required first, String? after}) {
          if (chatId == 'chat-1') return firstCompleter.future;
          return secondCompleter.future;
        },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      final emittedStates = <ChatMessagesState>[];
      final subscription = cubit.stream.listen(emittedStates.add);
      addTearDown(subscription.cancel);

      final firstLoad = cubit.loadMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);
      final secondLoad = cubit.loadMessages(chatId: 'chat-2');
      await Future<void>.delayed(Duration.zero);

      secondCompleter.complete(
        Right([_message(id: 'message-2', chatId: 'chat-2', content: 'Newest')]),
      );
      await Future<void>.delayed(Duration.zero);

      firstCompleter.complete(
        Right([_message(id: 'message-1', chatId: 'chat-1', content: 'Stale')]),
      );

      await Future.wait([firstLoad, secondLoad]);

      final loadedStates = emittedStates
          .whereType<ChatMessagesLoaded>()
          .toList();
      expect(loadedStates, hasLength(1));
      expect(loadedStates.single.chatId, 'chat-2');
      expect(loadedStates.single.messages.single.content, 'Newest');
      expect(cubit.state, isA<ChatMessagesLoaded>());
      expect((cubit.state as ChatMessagesLoaded).chatId, 'chat-2');
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

MessageEntity _message({
  required String id,
  required String chatId,
  required String content,
}) {
  return MessageEntity(
    id: id,
    chatId: chatId,
    senderId: 'user-1',
    content: content,
    type: 'TEXT',
    status: 'sent',
    createdAt: DateTime.parse('2026-04-18T08:02:14.879Z'),
  );
}
