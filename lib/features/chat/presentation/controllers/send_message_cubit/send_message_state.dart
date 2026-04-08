import 'package:pageui/features/chat/domain/entities/message_entity.dart';

sealed class SendMessageState {
  const SendMessageState();
}

final class SendMessageInitial extends SendMessageState {
  const SendMessageInitial();
}

final class SendMessageLoading extends SendMessageState {
  const SendMessageLoading();
}

final class SendMessageSuccess extends SendMessageState {
  final MessageEntity message;

  const SendMessageSuccess({required this.message});
}

final class SendMessageError extends SendMessageState {
  final String message;

  const SendMessageError({required this.message});
}
