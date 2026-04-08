import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

abstract class ChatRepo {
  Future<Either<Failure, ChatEntity>> createChat({
    required CreateChatParams params,
  });

  Future<
    Either<
      Failure,
      ({List<ChatEntity> chats, bool hasNextPage, String? endCursor})
    >
  >
  getChats({required int first, String? after});

  Future<Either<Failure, List<ChatEntity>>> searchChats({
    required String name,
    required int first,
  });

  Future<Either<Failure, MessageEntity>> sendMessage({
    required SendMessageParams params,
  });
}
