import 'dart:async';

import 'package:page_ui/features/chat/domain/entities/message_entity.dart';

class ChatSession {
  List<MessageEntity> messages = const [];
  bool hasNextPage = false;
  String? endCursor;
  // ignore: cancel_subscriptions
  StreamSubscription<MessageEntity>? subscription;
  String? selectedAiRunId;
  bool isHydrated = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isAwaitingAiResponse = false;

  /// True while a WebSocket subscription is open for this chat.
  /// The UI uses this to block the send input.
  bool isSubscriptionActive = false;

  /// Transient status bubble — shows animated bubble with dynamic content
  /// from backend. Cleared when AI_MESSAGE or AI_RUN arrives.
  MessageEntity? activeThinkingMessage;
}
