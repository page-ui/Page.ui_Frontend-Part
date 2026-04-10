import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/chat/data/data_source/chat_data_source.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatDataSource dataSource;
  final NetworkInfo networkInfo;

  ChatRepoImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ChatEntity>> createChat({
    required CreateChatParams params,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure.error());
      }
      final chat = await dataSource.createChat(params: params);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create chat.'));
    }
  }

  @override
  Future<
    Either<
      Failure,
      ({List<ChatEntity> chats, bool hasNextPage, String? endCursor})
    >
  >
  getChats({required int first, String? after}) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure.error());
      }
      final result = await dataSource.getChats(first: first, after: after);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load chats.'));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> searchChats({
    required String name,
    required int first,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure.error());
      }
      final result = await dataSource.searchChats(name: name, first: first);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search chats.'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required SendMessageParams params,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure.error());
      }
      await dataSource.sendMessage(params: params);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send message.'));
    }
  }
}
