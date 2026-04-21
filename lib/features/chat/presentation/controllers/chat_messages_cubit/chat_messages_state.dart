import 'package:pageui/features/chat/domain/entities/message_entity.dart';

sealed class ChatMessagesState {
  const ChatMessagesState();
}

final class ChatMessagesInitial extends ChatMessagesState {
  const ChatMessagesInitial();
}

final class ChatMessagesLoading extends ChatMessagesState {
  final String chatId;

  const ChatMessagesLoading({required this.chatId});
}

final class ChatMessagesLoaded extends ChatMessagesState {
  final String chatId;
  final List<MessageEntity> messages;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;
  final String? selectedAiRunMessageId;
  final bool isAwaitingAiResponse;

  const ChatMessagesLoaded({
    required this.chatId,
    required this.messages,
    this.hasNextPage = false,
    this.endCursor,
    this.isLoadingMore = false,
    this.selectedAiRunMessageId,
    this.isAwaitingAiResponse = false,
  });

  ChatMessagesLoaded copyWith({
    String? chatId,
    List<MessageEntity>? messages,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
    String? selectedAiRunMessageId,
    bool? isAwaitingAiResponse,
  }) {
    return ChatMessagesLoaded(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedAiRunMessageId:
          selectedAiRunMessageId ?? this.selectedAiRunMessageId,
      isAwaitingAiResponse:
          isAwaitingAiResponse ?? this.isAwaitingAiResponse,
    );
  }
}

final class ChatMessagesError extends ChatMessagesState {
  final String chatId;
  final String message;

  const ChatMessagesError({required this.chatId, required this.message});
}
