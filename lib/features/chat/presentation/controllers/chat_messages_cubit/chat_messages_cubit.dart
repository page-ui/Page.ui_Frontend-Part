import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/helpers/app_logger.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  ChatMessagesCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatMessagesInitial());

  static const int _pageSize = 16;

  final ChatRepo _chatRepo;

  final Map<String, List<MessageEntity>> _messagesByChatId = {};
  final Map<String, bool> _hasNextPageByChatId = {};
  final Map<String, String?> _endCursorByChatId = {};
  final Map<String, StreamSubscription<MessageEntity>> _subscriptionsByChatId =
      {};
  final Set<String> _hydratedChatIds = {};
  final Set<String> _loadingChatIds = {};
  final Set<String> _loadingMoreChatIds = {};

  String? _activeChatId;

  Future<void> openChat({required String chatId}) async {
    // Drop any cached state for this chat and tear down the previous
    // subscription / websocket so opening the panel always shows fresh
    // messages and a freshly reconnected stream.
    await _cancelSubscription(chatId);
    _messagesByChatId.remove(chatId);
    _hasNextPageByChatId.remove(chatId);
    _endCursorByChatId.remove(chatId);
    _hydratedChatIds.remove(chatId);
    _loadingChatIds.remove(chatId);
    _loadingMoreChatIds.remove(chatId);

    _activeChatId = chatId;
    _ensureSubscription(chatId);
    emit(ChatMessagesLoading(chatId: chatId));

    _loadingChatIds.add(chatId);
    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
    );
    _loadingChatIds.remove(chatId);

    result.fold(
      (failure) {
        if (_activeChatId == chatId) {
          emit(ChatMessagesError(chatId: chatId, message: failure.message));
        }
      },
      (response) {
        _hydratedChatIds.add(chatId);
        _messagesByChatId[chatId] = _mergeMessages(
          existing: _messagesByChatId[chatId] ?? const [],
          incoming: response.messages,
        );
        _hasNextPageByChatId[chatId] = response.hasNextPage;
        _endCursorByChatId[chatId] = response.endCursor;

        if (_activeChatId == chatId) {
          _emitLoaded(chatId);
        }
      },
    );
  }

  /// Tear down the subscription for [chatId] and reset the websocket so the
  /// panel is fully disconnected when closed.
  Future<void> closeChat({required String chatId}) async {
    await _cancelSubscription(chatId);
    if (_activeChatId == chatId) {
      _activeChatId = null;
      emit(const ChatMessagesInitial());
    }
    if (_subscriptionsByChatId.isEmpty) {
      await GraphQLConfig.disconnectWebSocket();
    }
  }

  Future<void> _cancelSubscription(String chatId) async {
    final subscription = _subscriptionsByChatId.remove(chatId);
    if (subscription != null) {
      await subscription.cancel();
    }
  }

  Future<void> loadMessages({required String chatId}) {
    return openChat(chatId: chatId);
  }

  Future<void> loadMoreMessages({required String chatId}) async {
    if (_loadingMoreChatIds.contains(chatId)) return;

    final hasNextPage = _hasNextPageByChatId[chatId] ?? false;
    if (!hasNextPage) return;

    final endCursor = _endCursorByChatId[chatId];
    if (endCursor == null) return;

    _loadingMoreChatIds.add(chatId);

    if (_activeChatId == chatId) {
      _emitLoaded(chatId, isLoadingMore: true);
    }

    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
      after: endCursor,
    );

    _loadingMoreChatIds.remove(chatId);

    result.fold(
      (failure) {
        if (_activeChatId == chatId) {
          _emitLoaded(chatId);
        }
      },
      (response) {
        _messagesByChatId[chatId] = _mergeMessages(
          existing: _messagesByChatId[chatId] ?? const [],
          incoming: response.messages,
        );
        _hasNextPageByChatId[chatId] = response.hasNextPage;
        _endCursorByChatId[chatId] = response.endCursor;

        if (_activeChatId == chatId) {
          _emitLoaded(chatId);
        }
      },
    );
  }

  void _ensureSubscription(String chatId) {
    if (_subscriptionsByChatId.containsKey(chatId)) {
      return;
    }

    final subscription = _chatRepo
        .subscribeToMessages(chatId: chatId)
        .listen(
          (message) {
            _messagesByChatId[chatId] = _mergeMessages(
              existing: _messagesByChatId[chatId] ?? const [],
              incoming: [message],
            );

            if (_activeChatId == chatId) {
              _emitLoaded(chatId);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            appLogger.e(
              'Message subscription error for $chatId',
              error: error,
              stackTrace: stackTrace,
            );
            if (_activeChatId == chatId &&
                (_messagesByChatId[chatId]?.isEmpty ?? true)) {
              emit(
                ChatMessagesError(
                  chatId: chatId,
                  message: 'Live message stream interrupted: $error',
                ),
              );
            }
          },
        );

    _subscriptionsByChatId[chatId] = subscription;
  }

  void _emitLoaded(String chatId, {bool isLoadingMore = false}) {
    final messages = List<MessageEntity>.from(
      _messagesByChatId[chatId] ?? const [],
    )..sort((first, second) => first.createdAt.compareTo(second.createdAt));

    emit(
      ChatMessagesLoaded(
        chatId: chatId,
        messages: List.unmodifiable(messages),
        hasNextPage: _hasNextPageByChatId[chatId] ?? false,
        endCursor: _endCursorByChatId[chatId],
        isLoadingMore: isLoadingMore,
      ),
    );
  }

  List<MessageEntity> _mergeMessages({
    required List<MessageEntity> existing,
    required Iterable<MessageEntity> incoming,
  }) {
    final messagesById = <String, MessageEntity>{
      for (final message in existing) message.id: message,
    };

    for (final message in incoming) {
      messagesById[message.id] = message;
    }

    return messagesById.values.toList()
      ..sort((first, second) => first.createdAt.compareTo(second.createdAt));
  }

  void reset() {
    for (final subscription in _subscriptionsByChatId.values) {
      subscription.cancel();
    }

    _subscriptionsByChatId.clear();
    _messagesByChatId.clear();
    _hasNextPageByChatId.clear();
    _endCursorByChatId.clear();
    _hydratedChatIds.clear();
    _loadingChatIds.clear();
    _loadingMoreChatIds.clear();
    _activeChatId = null;
    emit(const ChatMessagesInitial());
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptionsByChatId.values) {
      await subscription.cancel();
    }

    _subscriptionsByChatId.clear();
    return super.close();
  }
}
