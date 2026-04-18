import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/core/database/api/interceptors.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';

class GraphQLConfig {
  static String uri = 'http://localhost/graphql/';

  static String? accessToken;
  static String? refreshToken;
  static Future<UserTokensModel?>? _ongoingRefresh;

  static HttpLink httpLink = HttpLink(uri);
  static WebSocketLink webSocketLink = WebSocketLink(
    _webSocketUri,
    config: SocketClientConfig(
      autoReconnect: true,
      initialPayload: () async => _socketInitialPayload,
    ),
  );
  static GraphQLLoggerLink loggerLink = GraphQLLoggerLink();
  static AuthLink authLink = AuthLink(
    getToken: () async {
      if (accessToken == null) return null;
      return 'Bearer $accessToken';
    },
  );

  static ErrorLink errorLink = ErrorLink(
    onGraphQLError: (request, forward, response) async* {
      debugPrint('onGraphQLError fired');
      debugPrint('errors: ${response.errors}');
      debugPrint('refreshToken in memory: $refreshToken');

      if (!await _shouldRefreshRequest(request: request, response: response)) {
        yield response;
        return;
      }
      debugPrint('starting refresh...');

      final newTokens = await _refreshTokens();
      debugPrint('refresh result: ${newTokens?.accessToken}');

      if (newTokens == null) {
        yield response;
        return;
      }

      final retriedRequest = request.withContextEntry(
        const _AuthRetryContext(hasRetried: true),
      );
      debugPrint('retrying original request...');
      yield* forward(retriedRequest);
    },
  );

  static Link httpLinkChain = Link.from([
    errorLink,
    loggerLink,
    authLink,
    httpLink,
  ]);
  static Link link = Link.split(
    (request) => request.isSubscription,
    webSocketLink,
    httpLinkChain,
  );
  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  /// REST API client with refresh token support
  static late final dio.Dio restClient;

  static void initializeRestClient() {
    final baseUri = Uri.parse(uri);
    final apiBaseUrl = baseUri.replace(path: '/api/').toString();
    restClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    restClient.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && refreshToken != null) {
            debugPrint('REST API 401 - triggering token refresh');
            final newTokens = await _refreshTokens();
            if (newTokens != null) {
              // Retry the request with new token
              final retryOptions = error.requestOptions;
              retryOptions.headers['Authorization'] =
                  'Bearer ${newTokens.accessToken}';
              try {
                final retryResponse = await restClient.fetch(retryOptions);
                return handler.resolve(retryResponse);
              } catch (_) {
                // Retry failed, pass error through
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<bool> _shouldRefreshRequest({
    required Request request,
    required Response response,
  }) async {
    UserTokensModel tokens = await returnTokensFromSecureDB();
    refreshToken = tokens.refreshToken;
    accessToken = tokens.accessToken;

    debugPrint('operation: ${request.operation.operationName}');
    debugPrint('errors for auth check: ${response.errors}');
    debugPrint('stored refresh token: ${tokens.refreshToken}');
    if (refreshToken == null || refreshToken!.isEmpty) {
      return false;
    }

    if (request.operation.operationName == 'RefreshToken') {
      return false;
    }

    final retryContext = request.context.entry<_AuthRetryContext>();
    if (retryContext?.hasRetried == true) {
      return false;
    }

    return response.errors?.any(
          (error) => error.extensions?['code'] == 'AUTH_NOT_AUTHENTICATED',
        ) ==
        true;
  }

  static Future<UserTokensModel?> _refreshTokens() {
    final ongoingRefresh = _ongoingRefresh;
    if (ongoingRefresh != null) {
      return ongoingRefresh;
    }

    final completer = Completer<UserTokensModel?>();
    _ongoingRefresh = completer.future;

    () async {
      try {
        final refreshClient = GraphQLClient(
          link: httpLink,
          cache: GraphQLCache(store: InMemoryStore()),
        );
        log("I'm here");
        log("I'm here");
        final result = await refreshClient.mutate(
          MutationOptions(
            document: gql(Queries.refreshTokenMutation),
            variables: {'refreshToken': refreshToken},
            fetchPolicy: FetchPolicy.noCache,
          ),
        );

        final refreshedTokenPayload = result.data?['refreshToken'];
        if (result.hasException || refreshedTokenPayload == null) {
          await _clearTokens();
          completer.complete(null);
          return;
        }

        final newTokens = UserTokensModel.fromJson(
          refreshedTokenPayload as Map<String, dynamic>,
        );
        await _persistTokens(newTokens);
        completer.complete(newTokens);
      } catch (_) {
        await _clearTokens();
        completer.complete(null);
      } finally {
        _ongoingRefresh = null;
      }
    }();

    return completer.future;
  }

  static Future<void> _persistTokens(UserTokensModel tokens) async {
    accessToken = tokens.accessToken;
    refreshToken = tokens.refreshToken;
    await saveTokens(tokens);
  }

  static Future<void> _clearTokens() async {
    accessToken = null;
    refreshToken = null;
    await SecureStorage.deleteData(key: tokensKey);
  }

  static String get _webSocketUri {
    final parsedUri = Uri.parse(uri);
    final scheme = parsedUri.scheme == 'https' ? 'wss' : 'ws';
    return parsedUri.replace(scheme: scheme).toString();
  }

  static Map<String, dynamic> get _socketInitialPayload {
    if (accessToken == null || accessToken!.isEmpty) {
      return const {};
    }

    final authorization = 'Bearer $accessToken';
    return {
      'Authorization': authorization,
      'headers': {'Authorization': authorization},
    };
  }
}

Future<void> initializeAuth({required GraphQLConfig graph}) async {
  final token = await returnTokensFromSecureDB();

  GraphQLConfig.accessToken = token.accessToken;
  GraphQLConfig.refreshToken = token.refreshToken;
}

class _AuthRetryContext extends ContextEntry {
  const _AuthRetryContext({required this.hasRetried});

  final bool hasRetried;

  @override
  List<Object?> get fieldsForEquality => [hasRetried];
}
