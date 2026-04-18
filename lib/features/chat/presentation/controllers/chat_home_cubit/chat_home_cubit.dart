import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';

class ChatHomeCubit extends Cubit<ChatHomeState> {
  final ChatRepo _chatRepo;

  ChatHomeCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatHomeInitial());

  Future<void> createChat({
    required String name,
    required String content,
    String? attachmentUrl,
  }) async {
    final currentChat = state.selectedChat;
    emit(ChatHomeLoading(previousChat: currentChat));

    final result = await _chatRepo.createChat(
      params: CreateChatParams(
        name: name,
        content: content,
        attachmentUrl: attachmentUrl,
      ),
    );
    result.fold(
      (failure) => emit(
        ChatHomeError(message: failure.message, previousChat: currentChat),
      ),
      (chat) => emit(ChatHomeActive(chat: chat)),
    );
  }

  void selectChat({required ChatEntity chat}) {
    emit(ChatHomeActive(chat: chat));
  }

  void reset() {
    emit(const ChatHomeInitial());
  }
}
