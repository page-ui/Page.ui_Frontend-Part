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
    'ChatMessagesCubit hydrates a chat and starts one subscription',
    () async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<ChatMessagesLoaded>());
      final loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.chatId, 'chat-1');
      expect(loadedState.messages, hasLength(1));
      expect(loadedState.messages.single.content, 'Hello');
      expect(loadedState.hasNextPage, false);
      expect(repo.subscribeCallCount['chat-1'], 1);
    },
  );

  test(
    'ChatMessagesCubit emits error when history fetch fails with no cache',
    () async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Left(ServerFailure(message: 'Failed to load messages.'));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<ChatMessagesError>());

      final errorState = cubit.state as ChatMessagesError;
      expect(errorState.chatId, 'chat-1');
      expect(errorState.message, 'Failed to load messages.');
    },
  );

  test(
    'ChatMessagesCubit appends streamed messages into the active chat',
    () async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      controller.add(
        _message(
          id: 'message-2',
          chatId: 'chat-1',
          content: 'Realtime reply',
          type: 'AI_RUN',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.messages, hasLength(2));
      expect(
        loadedState.messages.map((message) => message.content),
        contains('Realtime reply'),
      );
    },
  );

  test(
    'ChatMessagesCubit dedupes streamed messages that already exist in history',
    () async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      controller.add(
        _message(id: 'message-1', chatId: 'chat-1', content: 'Hello again'),
      );
      await Future<void>.delayed(Duration.zero);

      final loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.messages, hasLength(1));
    },
  );

  test(
    'ChatMessagesCubit keeps old chat subscriptions alive while the active UI stays on the new chat',
    () async {
      final chatOneController = StreamController<MessageEntity>();
      final chatTwoController = StreamController<MessageEntity>();

      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(
                    id: 'history-$chatId',
                    chatId: chatId,
                    content: 'History $chatId',
                  ),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) {
          if (chatId == 'chat-1') {
            return chatOneController.stream;
          }
          return chatTwoController.stream;
        },
      );
      addTearDown(chatOneController.close);
      addTearDown(chatTwoController.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await cubit.openChat(chatId: 'chat-2');

      chatOneController.add(
        _message(
          id: 'chat-1-live',
          chatId: 'chat-1',
          content: 'Background update',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<ChatMessagesLoaded>());
      expect((cubit.state as ChatMessagesLoaded).chatId, 'chat-2');

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      final loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.chatId, 'chat-1');
      expect(
        loadedState.messages.map((message) => message.content),
        contains('Background update'),
      );
      expect(repo.subscribeCallCount['chat-1'], 1);
      expect(repo.subscribeCallCount['chat-2'], 1);
    },
  );

  test(
    'ChatMessagesCubit reuses cached chat data and does not create a second subscription',
    () async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(repo.subscribeCallCount['chat-1'], 1);
    },
  );

  test('ChatMessagesCubit cancels chat subscriptions when it closes', () async {
    final controller = StreamController<MessageEntity>();
    final repo = _FakeChatRepo(
      getMessagesHandler:
          ({required chatId, required first, String? after}) async {
            return Right((
              messages: [
                _message(id: 'message-1', chatId: chatId, content: 'Hello'),
              ],
              hasNextPage: false,
              endCursor: null,
            ));
          },
      subscribeToMessagesHandler: ({required chatId}) => controller.stream,
    );
    final cubit = ChatMessagesCubit(chatRepo: repo);

    await cubit.openChat(chatId: 'chat-1');

    expect(controller.hasListener, isTrue);

    await cubit.close();
    await Future<void>.delayed(Duration.zero);

    expect(controller.hasListener, isFalse);
    await controller.close();
  });

  test('ChatMessagesCubit loads more messages with pagination', () async {
    final repo = _FakeChatRepo(
      getMessagesHandler:
          ({required chatId, required first, String? after}) async {
            if (after == null) {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: true,
                endCursor: 'cursor-1',
              ));
            }
            return Right((
              messages: [
                _message(id: 'message-2', chatId: chatId, content: 'World'),
              ],
              hasNextPage: false,
              endCursor: 'cursor-2',
            ));
          },
    );
    final cubit = ChatMessagesCubit(chatRepo: repo);
    addTearDown(cubit.close);

    await cubit.openChat(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    var loadedState = cubit.state as ChatMessagesLoaded;
    expect(loadedState.messages, hasLength(1));
    expect(loadedState.hasNextPage, true);
    expect(loadedState.endCursor, 'cursor-1');

    await cubit.loadMoreMessages(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    loadedState = cubit.state as ChatMessagesLoaded;
    expect(loadedState.messages, hasLength(2));
    expect(loadedState.hasNextPage, false);
  });

  test(
    'ChatMessagesCubit sets isLoadingMore to true during pagination',
    () async {
      final completer =
          Completer<
            Either<
              Failure,
              ({
                List<MessageEntity> messages,
                bool hasNextPage,
                String? endCursor,
              })
            >
          >();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              if (after == null) {
                return Right((
                  messages: [
                    _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                  ],
                  hasNextPage: true,
                  endCursor: 'cursor-1',
                ));
              }
              return completer.future;
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      var loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.isLoadingMore, false);

      // Start loading more messages
      final loadFuture = cubit.loadMoreMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      // Check that isLoadingMore is true during the load
      loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.isLoadingMore, true);

      // Complete the load
      completer.complete(
        Right((
          messages: [
            _message(id: 'message-2', chatId: 'chat-1', content: 'World'),
          ],
          hasNextPage: false,
          endCursor: 'cursor-2',
        )),
      );

      await loadFuture;
      await Future<void>.delayed(Duration.zero);

      // Check that isLoadingMore is false after the load
      loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.isLoadingMore, false);
      expect(loadedState.messages, hasLength(2));
    },
  );

  test(
    'ChatMessagesCubit prevents concurrent loadMoreMessages calls',
    () async {
      var callCount = 0;
      final completer =
          Completer<
            Either<
              Failure,
              ({
                List<MessageEntity> messages,
                bool hasNextPage,
                String? endCursor,
              })
            >
          >();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              callCount++;
              if (after == null) {
                return Right((
                  messages: [
                    _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                  ],
                  hasNextPage: true,
                  endCursor: 'cursor-1',
                ));
              }
              return completer.future;
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      // Start two concurrent loadMoreMessages calls
      final loadFuture1 = cubit.loadMoreMessages(chatId: 'chat-1');
      final loadFuture2 = cubit.loadMoreMessages(chatId: 'chat-1');

      // Complete the first call
      completer.complete(
        Right((
          messages: [
            _message(id: 'message-2', chatId: 'chat-1', content: 'World'),
          ],
          hasNextPage: false,
          endCursor: 'cursor-2',
        )),
      );

      await Future.wait([loadFuture1, loadFuture2]);
      await Future<void>.delayed(Duration.zero);

      // Only one API call should have been made for pagination
      // (callCount = 1 for initial load + 1 for pagination = 2)
      expect(callCount, 2);
    },
  );

  test(
    'ChatMessagesCubit does not load more when hasNextPage is false',
    () async {
      var callCount = 0;
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              callCount++;
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      var loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.hasNextPage, false);

      await cubit.loadMoreMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      // Should not make another API call
      expect(callCount, 1);
    },
  );

  test('ChatMessagesCubit handles pagination error gracefully', () async {
    final repo = _FakeChatRepo(
      getMessagesHandler:
          ({required chatId, required first, String? after}) async {
            if (after == null) {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: true,
                endCursor: 'cursor-1',
              ));
            }
            return Left(ServerFailure(message: 'Pagination failed.'));
          },
    );
    final cubit = ChatMessagesCubit(chatRepo: repo);
    addTearDown(cubit.close);

    await cubit.openChat(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    var loadedState = cubit.state as ChatMessagesLoaded;
    expect(loadedState.messages, hasLength(1));
    expect(loadedState.hasNextPage, true);

    await cubit.loadMoreMessages(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    // Should keep existing messages on error
    loadedState = cubit.state as ChatMessagesLoaded;
    expect(loadedState.messages, hasLength(1));
    expect(loadedState.isLoadingMore, false);
  });

  test(
    'ChatMessagesCubit merges paginated messages correctly by createdAt',
    () async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              if (after == null) {
                return Right((
                  messages: [
                    _message(
                      id: 'message-3',
                      chatId: chatId,
                      content: 'Third',
                      createdAt: DateTime.parse('2026-04-18T08:03:00.000Z'),
                    ),
                    _message(
                      id: 'message-4',
                      chatId: chatId,
                      content: 'Fourth',
                      createdAt: DateTime.parse('2026-04-18T08:04:00.000Z'),
                    ),
                  ],
                  hasNextPage: true,
                  endCursor: 'cursor-1',
                ));
              }
              return Right((
                messages: [
                  _message(
                    id: 'message-1',
                    chatId: chatId,
                    content: 'First',
                    createdAt: DateTime.parse('2026-04-18T08:01:00.000Z'),
                  ),
                  _message(
                    id: 'message-2',
                    chatId: chatId,
                    content: 'Second',
                    createdAt: DateTime.parse('2026-04-18T08:02:00.000Z'),
                  ),
                ],
                hasNextPage: false,
                endCursor: 'cursor-2',
              ));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      var loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.messages, hasLength(2));

      await cubit.loadMoreMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      loadedState = cubit.state as ChatMessagesLoaded;
      expect(loadedState.messages, hasLength(4));
      // Messages should be sorted by createdAt ascending
      expect(loadedState.messages.map((m) => m.content), [
        'First',
        'Second',
        'Third',
        'Fourth',
      ]);
    },
  );

  test('ChatMessagesCubit does not load more when endCursor is null', () async {
    var callCount = 0;
    final repo = _FakeChatRepo(
      getMessagesHandler:
          ({required chatId, required first, String? after}) async {
            callCount++;
            return Right((
              messages: [
                _message(id: 'message-1', chatId: chatId, content: 'Hello'),
              ],
              hasNextPage: true,
              // Server returns hasNextPage true but no cursor
              endCursor: null,
            ));
          },
    );
    final cubit = ChatMessagesCubit(chatRepo: repo);
    addTearDown(cubit.close);

    await cubit.openChat(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    var loadedState = cubit.state as ChatMessagesLoaded;
    expect(loadedState.hasNextPage, true);
    expect(loadedState.endCursor, isNull);

    await cubit.loadMoreMessages(chatId: 'chat-1');
    await Future<void>.delayed(Duration.zero);

    // Should not make another API call since endCursor is null
    expect(callCount, 1);
  });

  test(
    'ChatMessagesCubit does not load more before initial hydration',
    () async {
      var callCount = 0;
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              callCount++;
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: true,
                endCursor: 'cursor-1',
              ));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      // Try to load more before opening the chat
      await cubit.loadMoreMessages(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      // Should not make any API calls
      expect(callCount, 0);

      // Now open the chat
      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(callCount, 1);
    },
  );

  test(
    'ChatMessagesCubit emits error state when subscription stream errors and no cache',
    () async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return const Right((
                messages: <MessageEntity>[],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      controller.addError(StateError('socket dropped'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<ChatMessagesError>());
      final errorState = cubit.state as ChatMessagesError;
      expect(errorState.chatId, 'chat-1');
      expect(errorState.message, contains('socket dropped'));
    },
  );

  test(
    'ChatMessagesCubit keeps loaded state when subscription errors with cached messages',
    () async {
      final controller = StreamController<MessageEntity>();
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(id: 'message-1', chatId: chatId, content: 'Hello'),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
        subscribeToMessagesHandler: ({required chatId}) => controller.stream,
      );
      addTearDown(controller.close);
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      controller.addError(StateError('socket dropped'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<ChatMessagesLoaded>());
    },
  );

  test(
    'selectAiRunMessage updates activeAiRunUrl to the picked AI message URL',
    () async {
      final repo = _FakeChatRepo(
        getMessagesHandler:
            ({required chatId, required first, String? after}) async {
              return Right((
                messages: [
                  _message(
                    id: 'ai-old',
                    chatId: chatId,
                    content: '/runs/old/preview.html',
                    type: 'AI_RUN',
                    createdAt: DateTime.parse('2026-04-18T08:00:00Z'),
                  ),
                  _message(
                    id: 'ai-new',
                    chatId: chatId,
                    content: '/runs/new/preview.html',
                    type: 'AI_RUN',
                    createdAt: DateTime.parse('2026-04-18T09:00:00Z'),
                  ),
                ],
                hasNextPage: false,
                endCursor: null,
              ));
            },
      );
      final cubit = ChatMessagesCubit(chatRepo: repo);
      addTearDown(cubit.close);

      await cubit.openChat(chatId: 'chat-1');
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state.activeAiRunUrl,
        'http://localhost/runs/new/preview.html',
      );

      cubit.selectAiRunMessage(chatId: 'chat-1', messageId: 'ai-old');

      expect(
        cubit.state.activeAiRunUrl,
        'http://localhost/runs/old/preview.html',
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
  Function({required String chatId, required int first, String? after})
  getMessagesHandler;
  final Stream<MessageEntity> Function({required String chatId})
  _subscribeToMessagesHandler;
  final Map<String, int> subscribeCallCount = {};

  @override
  Future<
    Either<
      Failure,
      ({List<MessageEntity> messages, bool hasNextPage, String? endCursor})
    >
  >
  getMessages({required String chatId, required int first, String? after}) =>
      getMessagesHandler(chatId: chatId, first: first, after: after);

  @override
  Stream<MessageEntity> subscribeToMessages({required String chatId}) {
    subscribeCallCount.update(chatId, (value) => value + 1, ifAbsent: () => 1);
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
  
  @override
  Future<Either<Failure, void>> deleteChat({required String chatId}) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, ChatEntity>> renameChat({required String chatId, required String name}) {
    // TODO: implement renameChat
    throw UnimplementedError();
  }
}

MessageEntity _message({
  required String id,
  required String chatId,
  required String content,
  String type = 'TEXT',
  DateTime? createdAt,
}) {
  return MessageEntity(
    id: id,
    chatId: chatId,
    senderId: type == 'AI_RUN'
        ? '00000000-0000-0000-0000-000000000001'
        : 'user-1',
    content: content,
    type: type,
    status: 'sent',
    createdAt: createdAt ?? DateTime.parse('2026-04-18T08:02:14.879Z'),
  );
}
