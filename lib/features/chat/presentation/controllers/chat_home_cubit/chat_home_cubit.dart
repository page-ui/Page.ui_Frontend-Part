import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/errors/app_operation.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/core/helpers/app_logger.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/usecases/create_chat_usecase.dart';
import 'package:pageui/features/chat/domain/usecases/upload_attachment_usecase.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';

class ChatHomeCubit extends Cubit<ChatHomeState> {
  final CreateChatUseCase _createChat;

  ChatHomeCubit({required CreateChatUseCase createChat})
    : _createChat = createChat,
      super(const ChatHomeInitial());

  Future<void> createChat({
    required String name,
    required String content,
    UploadAttachmentInput? attachment,
  }) async {
    if (state is ChatHomeLoading) return;
    final currentChat = state.selectedChat;
    emit(ChatHomeLoading(previousChat: currentChat));

    try {
      final result = await _createChat(
        name: name,
        content: content,
        attachment: attachment,
      );
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          ChatHomeError(message: failure.message, previousChat: currentChat),
        ),
        (chat) => emit(ChatHomeActive(chat: chat)),
      );
    } catch (e, stackTrace) {
      appLogger.e(
        'ChatHomeCubit.createChat unexpected',
        error: e,
        stackTrace: stackTrace,
      );
      if (isClosed) return;
      emit(
        ChatHomeError(
          message: ServerFailure.forOperation(AppOperation.createChat).message,
          previousChat: currentChat,
        ),
      );
    }
  }

  void selectChat({required ChatEntity chat}) {
    emit(ChatHomeActive(chat: chat));
  }

  void updateSelectedChat({required ChatEntity chat}) {
    if (state.selectedChat?.id != chat.id) return;
    emit(ChatHomeActive(chat: chat));
  }

  void reset() {
    emit(const ChatHomeInitial());
  }
}
