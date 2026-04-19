import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/domain/usecases/upload_attachment_usecase.dart';

class SendMessageUseCase {
  final ChatRepo _chatRepo;
  final UploadAttachmentUseCase _uploadAttachment;

  SendMessageUseCase({
    required ChatRepo chatRepo,
    required UploadAttachmentUseCase uploadAttachment,
  }) : _chatRepo = chatRepo,
       _uploadAttachment = uploadAttachment;

  Future<Either<Failure, void>> call({
    required SendMessageParams params,
    UploadAttachmentInput? attachment,
  }) async {
    SendMessageParams finalParams = params;
    if (attachment != null) {
      final downloadUrl = await _uploadAttachment(attachment);
      finalParams = params.copyWith(attachmentUrl: downloadUrl);
    }
    return _chatRepo.sendMessage(params: finalParams);
  }
}
