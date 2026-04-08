import 'package:pageui/features/chat/domain/entities/message_entity.dart';

sealed class SendMessageState {
  const SendMessageState();
}

final class SendMessageInitial extends SendMessageState {
  const SendMessageInitial();
}

final class MessagesLoading extends SendMessageState {
  const MessagesLoading();
}

final class MessagesLoaded extends SendMessageState {
  final List<MessageEntity> messages;
  final bool hasNextPage;
  final String? endCursor;
  final bool isSending;

  const MessagesLoaded({
    required this.messages,
    required this.hasNextPage,
    this.endCursor,
    this.isSending = false,
  });

  MessagesLoaded copyWith({
    List<MessageEntity>? messages,
    bool? hasNextPage,
    String? endCursor,
    bool? isSending,
  }) {
    return MessagesLoaded(
      messages: messages ?? this.messages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      isSending: isSending ?? this.isSending,
    );
  }
}

final class SendMessageError extends SendMessageState {
  final String message;
  final List<MessageEntity> previousMessages;

  const SendMessageError({
    required this.message,
    this.previousMessages = const [],
  });
}
