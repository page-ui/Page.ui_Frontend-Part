import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/domain/usecases/upload_attachment_usecase.dart';

class CreateChatUseCase {
  final ChatRepo _chatRepo;
  final UploadAttachmentUseCase _uploadAttachment;

  CreateChatUseCase({
    required ChatRepo chatRepo,
    required UploadAttachmentUseCase uploadAttachment,
  }) : _chatRepo = chatRepo,
       _uploadAttachment = uploadAttachment;

  Future<Either<Failure, ChatEntity>> call({
    required String name,
    required String content,
    UploadAttachmentInput? attachment,
  }) async {
    String? attachmentUrl;
    if (attachment != null) {
      attachmentUrl = await _uploadAttachment(attachment);
    }
    return _chatRepo.createChat(
      params: CreateChatParams(
        name: name,
        content: content,
        attachmentUrl: attachmentUrl,
      ),
    );
  }
}
