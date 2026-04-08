import 'package:pageui/features/chat/domain/entities/message_entity.dart';

sealed class ChatMessagesState {
  const ChatMessagesState();
}

final class ChatMessagesInitial extends ChatMessagesState {
  const ChatMessagesInitial();
}

final class ChatMessagesLoaded extends ChatMessagesState {
  final List<MessageEntity> messages;

  const ChatMessagesLoaded({required this.messages});
}
