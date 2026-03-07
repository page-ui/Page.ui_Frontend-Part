import 'package:pageui/features/chat/domain/entities/chat_entity.dart';

sealed class ChatHomeState {
  const ChatHomeState();
}

final class ChatHomeInitial extends ChatHomeState {
  const ChatHomeInitial();
}

final class ChatHomeLoading extends ChatHomeState {
  const ChatHomeLoading();
}

final class ChatHomeActive extends ChatHomeState {
  final ChatEntity chat;
  const ChatHomeActive({required this.chat});
}

final class ChatHomeError extends ChatHomeState {
  final String message;
  const ChatHomeError({required this.message});
}
