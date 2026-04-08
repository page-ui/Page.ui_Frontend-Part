import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/data/data_source/upload_service.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final ChatRepo _chatRepo;
  final UploadService _uploadService;
  Uint8List? _imageBytes;
  String? _imageFileName;
  String? _imageContentType;

  SendMessageCubit({required ChatRepo chatRepo, UploadService? uploadService})
    : _chatRepo = chatRepo,
      _uploadService = uploadService ?? UploadService(),
      super(const SendMessageInitial());

  Future<void> loadMessages({required String chatId}) async {
    emit(const MessagesLoading());
    final result = await _chatRepo.getMessages(chatId: chatId, first: 20);
    result.fold(
      (failure) => emit(SendMessageError(message: failure.message)),
      (data) => emit(
        MessagesLoaded(
          messages: data.messages,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> loadMoreMessages({required String chatId}) async {
    final current = state;
    if (current is! MessagesLoaded || !current.hasNextPage) return;

    final result = await _chatRepo.getMessages(
      chatId: chatId,
      first: 20,
      after: current.endCursor,
    );

    result.fold(
      (_) {},
      (data) => emit(
        MessagesLoaded(
          messages: [...current.messages, ...data.messages],
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  void setImageData({
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) {
    _imageBytes = bytes;
    _imageFileName = fileName;
    _imageContentType = contentType;
  }

  void clearImageData() {
    _imageBytes = null;
    _imageFileName = null;
    _imageContentType = null;
  }

  bool hasImage() => _imageBytes != null;

  Future<void> sendMessage({required SendMessageParams params}) async {
    final current = state;

    if (current is MessagesLoaded) {
      emit(current.copyWith(isSending: true));
    }

    try {
      MessageEntity? message;

      if (_imageBytes != null && _imageFileName != null) {
        // Upload image and send message with attachment
        await _uploadService.uploadAndSendImage(
          fileBytes: _imageBytes!,
          fileName: _imageFileName!,
          contentType: _imageContentType ?? 'image/png',
          chatId: params.chatId,
        );
        await loadMessages(chatId: params.chatId);
        return;
      } else {
        final result = await _chatRepo.sendMessage(params: params);
        result.fold(
          (failure) {
            emit(
              SendMessageError(
                message: failure.message,
                previousMessages: current is MessagesLoaded
                    ? current.messages
                    : const [],
              ),
            );
            return;
          },
          (newMessage) {
            message = newMessage;
          },
        );
      }

      List<MessageEntity>? updatedMessages = current is MessagesLoaded
          ? [...current.messages, ?message]
          : [?message];
      emit(
        MessagesLoaded(
          messages: updatedMessages,
          hasNextPage: current is MessagesLoaded ? current.hasNextPage : false,
          endCursor: current is MessagesLoaded ? current.endCursor : null,
        ),
      );
    } catch (e) {
      emit(
        SendMessageError(
          message: e.toString(),
          previousMessages: current is MessagesLoaded
              ? current.messages
              : const [],
        ),
      );
    }
  }

  void reset() {
    emit(const SendMessageInitial());
  }
}
