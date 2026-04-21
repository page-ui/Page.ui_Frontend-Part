import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/helpers/app_logger.dart';
import 'package:pageui/features/chat/domain/constants/message_types.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/_chat_session.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  ChatMessagesCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatMessagesInitial());

  static const int _pageSize = 16;

  final ChatRepo _chatRepo;
  final Map<String, ChatSession> _sessions = {};
  String? _activeChatId;

  ChatSession _session(String chatId) =>
      _sessions.putIfAbsent(chatId, ChatSession.new);

  Future<void> openChat({required String chatId}) async {
    await _cancelSubscription(chatId);
    _sessions.remove(chatId);

    _activeChatId = chatId;
    final session = _session(chatId);
    session.isLoading = true;
    _ensureSubscription(chatId);
    emit(ChatMessagesLoading(chatId: chatId));

    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
    );
    if (isClosed) return;
    session.isLoading = false;

    result.fold(
      (failure) {
        if (_activeChatId == chatId) {
          emit(ChatMessagesError(chatId: chatId, message: failure.message));
        }
      },
      (response) {
        session.isHydrated = true;
        session.messages = _mergeMessages(session.messages, response.messages);
        session.hasNextPage = response.hasNextPage;
        session.endCursor = response.endCursor;

        if (_activeChatId == chatId) _emitLoaded(chatId);
      },
    );
  }

  Future<void> closeChat({required String chatId}) async {
    await _cancelSubscription(chatId);
    if (_activeChatId == chatId) {
      _activeChatId = null;
      emit(const ChatMessagesInitial());
    }
    final anySubLeft = _sessions.values.any((s) => s.subscription != null);
    if (!anySubLeft) {
      await GraphQLConfig.disconnectWebSocket();
    }
  }

  Future<void> _cancelSubscription(String chatId) async {
    final session = _sessions[chatId];
    final sub = session?.subscription;
    session?.subscription = null;
    if (sub != null) await sub.cancel();
  }

  Future<void> loadMoreMessages({required String chatId}) async {
    final session = _sessions[chatId];
    if (session == null) return;
    if (session.isLoadingMore || !session.hasNextPage) return;
    final endCursor = session.endCursor;
    if (endCursor == null) return;

    session.isLoadingMore = true;
    if (_activeChatId == chatId) _emitLoaded(chatId);

    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
      after: endCursor,
    );
    if (isClosed) return;
    session.isLoadingMore = false;

    result.fold(
      (_) {
        if (_activeChatId == chatId) _emitLoaded(chatId);
      },
      (response) {
        session.messages = _mergeMessages(session.messages, response.messages);
        session.hasNextPage = response.hasNextPage;
        session.endCursor = response.endCursor;
        if (_activeChatId == chatId) _emitLoaded(chatId);
      },
    );
  }

  void _ensureSubscription(String chatId) {
    final session = _session(chatId);
    if (session.subscription != null) return;

    // ignore: cancel_subscriptions
    session.subscription = _chatRepo
        .subscribeToMessages(chatId: chatId)
        .listen(
          (message) {
            if (isClosed) return;
            session.messages = _mergeMessages(session.messages, [message]);

            if (isAiMessageType(message.type)) {
              session.selectedAiRunId = message.id;
              session.isAwaitingAiResponse = false;
            }

            if (_activeChatId == chatId) _emitLoaded(chatId);
          },
          onError: (Object error, StackTrace stackTrace) {
            appLogger.e(
              'Message subscription error for $chatId',
              error: error,
              stackTrace: stackTrace,
            );
            if (isClosed) return;
            session.isAwaitingAiResponse = false;
            if (_activeChatId != chatId) return;
            if (session.messages.isEmpty) {
              emit(
                ChatMessagesError(
                  chatId: chatId,
                  message: 'Live message stream interrupted: $error',
                ),
              );
            } else {
              _emitLoaded(chatId);
            }
          },
        );
  }

  void selectAiRunMessage({required String chatId, required String messageId}) {
    final session = _sessions[chatId];
    if (session == null) return;
    session.selectedAiRunId = messageId;
    if (_activeChatId == chatId && session.isHydrated) _emitLoaded(chatId);
  }

  void markAwaitingAiResponse({required String chatId}) {
    final session = _session(chatId);
    session.isAwaitingAiResponse = true;
    if (_activeChatId == chatId && session.isHydrated) _emitLoaded(chatId);
  }

  void _emitLoaded(String chatId) {
    final session = _session(chatId);
    final sorted = [...session.messages]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    emit(
      ChatMessagesLoaded(
        chatId: chatId,
        messages: List.unmodifiable(sorted),
        hasNextPage: session.hasNextPage,
        endCursor: session.endCursor,
        isLoadingMore: session.isLoadingMore,
        selectedAiRunMessageId: session.selectedAiRunId,
        isAwaitingAiResponse: session.isAwaitingAiResponse,
      ),
    );
  }

  List<MessageEntity> _mergeMessages(
    List<MessageEntity> existing,
    Iterable<MessageEntity> incoming,
  ) {
    final byId = <String, MessageEntity>{for (final m in existing) m.id: m};
    for (final m in incoming) {
      byId[m.id] = m;
    }
    return byId.values.toList(growable: false);
  }

  @override
  Future<void> close() async {
    for (final session in _sessions.values) {
      final sub = session.subscription;
      session.subscription = null;
      if (sub != null) await sub.cancel();
    }
    _sessions.clear();
    return super.close();
  }
}
