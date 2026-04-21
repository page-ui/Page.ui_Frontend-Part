import 'dart:async';

import 'package:pageui/features/chat/domain/entities/message_entity.dart';

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
}
