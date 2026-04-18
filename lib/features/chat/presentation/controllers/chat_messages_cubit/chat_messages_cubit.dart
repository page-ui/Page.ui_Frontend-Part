import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  ChatMessagesCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatMessagesInitial());

  static const int _pageSize = 15;

  final ChatRepo _chatRepo;

  String? _activeChatId;
  int _requestId = 0;

  Future<void> loadMessages({required String chatId}) async {
    _activeChatId = chatId;
    final requestId = ++_requestId;

    emit(ChatMessagesLoading(chatId: chatId));

    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: _pageSize,
    );

    if (requestId != _requestId || _activeChatId != chatId) {
      return;
    }

    result.fold(
      (failure) =>
          emit(ChatMessagesError(chatId: chatId, message: failure.message)),
      (messages) => emit(
        ChatMessagesLoaded(
          chatId: chatId,
          messages: List.unmodifiable(messages),
        ),
      ),
    );
  }

  void reset() {
    _activeChatId = null;
    _requestId++;
    emit(const ChatMessagesInitial());
  }
}
