import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/helpers/app_logger.dart';
import 'package:pageui/features/chat/domain/constants/message_types.dart';
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
  final Map<String, String?> _selectedAiRunByChatId = {};
  final Set<String> _awaitingAiResponseChatIds = {};

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
    _selectedAiRunByChatId.remove(chatId);
    _awaitingAiResponseChatIds.remove(chatId);

    _activeChatId = chatId;
    _ensureSubscription(chatId);
    emit(ChatMessagesLoading(chatId: chatId));

    _loadingChatIds.add(chatId);
    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
    );
    _loadingChatIds.remove(chatId);
    if (isClosed) return;

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
    if (isClosed) return;

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

    // ignore: cancel_subscriptions
    final subscription = _chatRepo
        .subscribeToMessages(chatId: chatId)
        .listen(
          (message) {
            if (isClosed) return;
            _messagesByChatId[chatId] = _mergeMessages(
              existing: _messagesByChatId[chatId] ?? const [],
              incoming: [message],
            );

            if (isAiMessageType(message.type)) {
              _selectedAiRunByChatId[chatId] = message.id;
              _awaitingAiResponseChatIds.remove(chatId);
            }

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
            if (isClosed) return;
            _awaitingAiResponseChatIds.remove(chatId);
            if (_activeChatId == chatId &&
                (_messagesByChatId[chatId]?.isEmpty ?? true)) {
              emit(
                ChatMessagesError(
                  chatId: chatId,
                  message: 'Live message stream interrupted: $error',
                ),
              );
            } else if (_activeChatId == chatId) {
              _emitLoaded(chatId);
            }
          },
        );
    _subscriptionsByChatId[chatId] = subscription;
  }

  void selectAiRunMessage({required String chatId, required String messageId}) {
    _selectedAiRunByChatId[chatId] = messageId;
    if (_activeChatId == chatId && _hydratedChatIds.contains(chatId)) {
      _emitLoaded(chatId);
    }
  }

  void markAwaitingAiResponse({required String chatId}) {
    _awaitingAiResponseChatIds.add(chatId);
    if (_activeChatId == chatId && _hydratedChatIds.contains(chatId)) {
      _emitLoaded(chatId);
    }
  }

  String? activeAiRunUrl([ChatMessagesState? fromState]) {
    final source = fromState ?? state;
    if (source is! ChatMessagesLoaded) return null;

    final target =
        _selectedAiMessage(source) ?? _latestAiMessage(source.messages);
    if (target == null) return null;

    final content = target.content.trim();
    if (content.isEmpty) return null;
    if (content.startsWith('/')) return 'http://localhost$content';
    return content;
  }

  MessageEntity? _selectedAiMessage(ChatMessagesLoaded state) {
    final selectedId = state.selectedAiRunMessageId;
    if (selectedId == null) return null;
    for (final message in state.messages) {
      if (message.id != selectedId) continue;
      if (!isAiMessageType(message.type)) return null;
      return message.content.trim().isEmpty ? null : message;
    }
    return null;
  }

  MessageEntity? _latestAiMessage(List<MessageEntity> messages) {
    for (final message in messages.reversed) {
      if (!isAiMessageType(message.type)) continue;
      if (message.content.trim().isEmpty) continue;
      return message;
    }
    return null;
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
        selectedAiRunMessageId: _selectedAiRunByChatId[chatId],
        isAwaitingAiResponse: _awaitingAiResponseChatIds.contains(chatId),
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

    // Sorting is deferred to _emitLoaded to avoid sorting twice per update.
    return messagesById.values.toList(growable: false);
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
