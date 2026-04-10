import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/data/data_source/upload_service.dart';
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

  bool get hasImage => _imageBytes != null;

  Future<void> sendMessage({required SendMessageParams params}) async {
    emit(const SendMessageLoading());

    try {
      SendMessageParams finalParams = params;

      if (_imageBytes != null && _imageFileName != null) {
        final downloadUrl = await _uploadService.upload(
          fileBytes: _imageBytes!,
          fileName: _imageFileName!,
          contentType: _imageContentType ?? 'image/png',
        );

        finalParams = params.copyWith(attachmentUrl: downloadUrl);
        clearImageData();
      }

      final result = await _chatRepo.sendMessage(params: finalParams);
      result.fold(
        (failure) => emit(SendMessageError(message: failure.message)),
        (_) => emit(const SendMessageSuccess()),
      );
    } catch (e) {
      emit(SendMessageError(message: e.toString()));
    }
  }

  void reset() {
    clearImageData();
    emit(const SendMessageInitial());
  }
}
