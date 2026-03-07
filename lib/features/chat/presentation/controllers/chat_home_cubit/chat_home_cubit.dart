import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';

class ChatHomeCubit extends Cubit<ChatHomeState> {
  final ChatRepo _chatRepo;

  ChatHomeCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatHomeInitial());

  Future<void> createChat({required String name}) async {
    emit(const ChatHomeLoading());
    final result = await _chatRepo.createChat(
      params: CreateChatParams(name: name),
    );
    result.fold(
      (failure) => emit(ChatHomeError(message: failure.message)),
      (chat) => emit(ChatHomeActive(chat: chat)),
    );
  }

  void selectChat({required chat}) {
    emit(ChatHomeActive(chat: chat));
  }

  void reset() {
    emit(const ChatHomeInitial());
  }
}
