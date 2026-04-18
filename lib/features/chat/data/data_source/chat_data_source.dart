import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/features/chat/data/models/chat_model.dart';
import 'package:pageui/features/chat/data/models/message_model.dart';
import 'package:pageui/features/chat/domain/params/create_chat_params.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

abstract class ChatDataSource {
  Future<ChatModel> createChat({required CreateChatParams params});

  Future<({List<ChatModel> chats, bool hasNextPage, String? endCursor})>
  getChats({required int first, String? after});

  Future<List<ChatModel>> searchChats({
    required String name,
    required int first,
  });

  Future<({List<MessageModel> messages, bool hasNextPage, String? endCursor})>
  getMessages({
    required String chatId,
    required int first,
    String? after,
  });

  Stream<MessageModel> subscribeToMessages({required String chatId});

  Future<void> sendMessage({required SendMessageParams params});
}

class ChatDataSourceImpl extends ChatDataSource {
  GraphQLClient get _client => GraphQLConfig.client.value;

  @override
  Future<ChatModel> createChat({required CreateChatParams params}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.createChatRoomMutation),
        variables: {'input': params.toInputJson()},
      ),
    );

    if (result.exception != null) {
      throw Exception('Failed to create chat: ${result.exception.toString()}');
    }

    if (result.data?['createChat'] == null) {
      throw Exception('Failed to create chat. Server returned no data.');
    }

    return ChatModel.fromJson(
      result.data!['createChat'] as Map<String, dynamic>,
    );
  }

  @override
  Future<({List<ChatModel> chats, bool hasNextPage, String? endCursor})>
  getChats({required int first, String? after}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(Queries.chatRoomsQuery),
        variables: {'first': first, if (after != null) 'after': after},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to load chats: ${result.exception.toString()}');
    }

    if (result.data?['chats'] == null) {
      throw Exception('Failed to load chats. Server returned no data.');
    }

    final data = result.data!['chats'] as Map<String, dynamic>;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>;
    final nodes = data['nodes'] as List;

    final chats = nodes
        .map((node) => ChatModel.fromJson(node as Map<String, dynamic>))
        .toList();

    return (
      chats: chats,
      hasNextPage: pageInfo['hasNextPage'] as bool,
      endCursor: pageInfo['endCursor'] as String?,
    );
  }

  @override
  Future<List<ChatModel>> searchChats({
    required String name,
    required int first,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(Queries.searchChatQuery),
        variables: {'name': name, 'first': first},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.exception != null || result.data?['searchChats'] == null) {
      throw Exception('Failed to search chats.');
    }

    final data = result.data!['searchChats'] as Map<String, dynamic>;
    final nodes = data['nodes'] as List;

    final chats = nodes
        .map((n) => ChatModel.fromJson(n as Map<String, dynamic>))
        .toList();

    return chats;
  }

  @override
  Future<({List<MessageModel> messages, bool hasNextPage, String? endCursor})>
  getMessages({
    required String chatId,
    required int first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(Queries.getMessagesQuery),
        variables: {
          'chatId': chatId,
          'first': first,
          if (after != null) 'after': after,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(
        'Failed to load messages: ${result.exception.toString()}',
      );
    }

    if (result.data?['messages'] == null) {
      throw Exception('Failed to load messages. Server returned no data.');
    }

    final data = result.data!['messages'] as Map<String, dynamic>;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>;
    final nodes = (data['nodes'] as List?) ?? const [];

    final messages = nodes
        .map(
          (node) => MessageModel.fromJson(
            node as Map<String, dynamic>,
            fallbackChatId: chatId,
          ),
        )
        .toList();

    return (
      messages: messages,
      hasNextPage: pageInfo['hasNextPage'] as bool,
      endCursor: pageInfo['endCursor'] as String?,
    );
  }

  @override
  Stream<MessageModel> subscribeToMessages({required String chatId}) async* {
    final stream = _client.subscribe(
      SubscriptionOptions(
        document: gql(Queries.onMessageCreatedSubscription),
        variables: {'chatId': chatId},
      ),
    );

    await for (final result in stream) {
      if (result.hasException) {
        throw Exception(
          'Failed to subscribe to messages: ${result.exception.toString()}',
        );
      }

      final payload = result.data?['onMessageCreated'];
      if (payload == null) {
        continue;
      }

      yield MessageModel.fromJson(
        payload as Map<String, dynamic>,
        fallbackChatId: chatId,
      );
    }
  }

  @override
  Future<void> sendMessage({required SendMessageParams params}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.sendMessageMutation),
        variables: {'input': params.toInputJson()},
      ),
    );

    if (result.hasException || result.data?['createMessage'] == null) {
      throw Exception('Failed to send message.');
    }
  }
}
