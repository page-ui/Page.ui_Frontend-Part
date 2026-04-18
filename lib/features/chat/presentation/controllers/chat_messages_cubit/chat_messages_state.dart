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

  const ChatMessagesLoaded({required this.chatId, required this.messages});
}

final class ChatMessagesError extends ChatMessagesState {
  final String chatId;
  final String message;

  const ChatMessagesError({required this.chatId, required this.message});
}
