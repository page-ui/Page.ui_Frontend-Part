import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/core/helpers/app_logger.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/chat/data/data_source/chat_data_source.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatDataSource dataSource;
  final NetworkInfo networkInfo;

  ChatRepoImpl({required this.dataSource, required this.networkInfo});

  Future<Either<Failure, T>> _guard<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure.error());
      }
      return Right(await action());
    } catch (e, stackTrace) {
      appLogger.e('ChatRepo.$operation failed', error: e, stackTrace: stackTrace);
      return Left(ServerFailure(message: 'Failed to $operation: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createChat({
    required CreateChatParams params,
  }) {
    return _guard('create chat', () => dataSource.createChat(params: params));
  }

  @override
  Future<
    Either<
      Failure,
      ({List<ChatEntity> chats, bool hasNextPage, String? endCursor})
    >
  >
  getChats({required int first, String? after}) {
    return _guard(
      'load chats',
      () => dataSource.getChats(first: first, after: after),
    );
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> searchChats({
    required String name,
    required int first,
  }) {
    return _guard(
      'search chats',
      () => dataSource.searchChats(name: name, first: first),
    );
  }

  @override
  Future<
    Either<
      Failure,
      ({List<MessageEntity> messages, bool hasNextPage, String? endCursor})
    >
  >
  getMessages({
    required String chatId,
    required int first,
    String? after,
  }) {
    return _guard(
      'load messages',
      () => dataSource.getMessages(chatId: chatId, first: first, after: after),
    );
  }

  @override
  Stream<MessageEntity> subscribeToMessages({required String chatId}) {
    return dataSource.subscribeToMessages(chatId: chatId);
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required SendMessageParams params,
  }) {
    return _guard(
      'send message',
      () => dataSource.sendMessage(params: params),
    );
  }
}
