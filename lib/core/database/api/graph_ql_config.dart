import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';

class GraphQLConfig {
  static String uri = 'http://localhost/graphql/';

  static String? accessToken;
  static String? refreshToken;

  static HttpLink httpLink = HttpLink(uri);

  static AuthLink authLink = AuthLink(
    getToken: () async {
      if (accessToken == null) return null;
      return 'Bearer $accessToken';
    },
  );

  static ErrorLink errorLink = ErrorLink(
    onGraphQLError: (request, forward, response) async* {
      final isUnauthenticated = response.errors?.any(
        (e) => e.extensions?['code'] == 'UNAUTHENTICATED',
      );

      if (isUnauthenticated == true && refreshToken != null) {
        final newTokens = await _refreshToken();

        if (newTokens != null) {
          accessToken = newTokens.accessToken;
          refreshToken = newTokens.refreshToken;
          yield* forward(request);
        }
      } else {
        yield response;
      }
    },
  );

  static Link link = errorLink.concat(authLink.concat(httpLink));

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  static Future<UserTokensModel?> _refreshToken() async {
    final client = GraphQLClient(link: httpLink, cache: GraphQLCache());

    final result = await client.mutate(
      MutationOptions(
        document: gql(Queries.refreshTokenMutation),
        variables: {"token": refreshToken},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException || result.data == null) {
      accessToken = null;
      refreshToken = null;
      return null;
    }

    return UserTokensModel.fromJson(result.data!['refreshToken']);
  }
}

Future<void> initializeAuth({required GraphQLConfig graph}) async {
  final token = await returnTokensFromSecureDB();

  GraphQLConfig.accessToken = token.accessToken;
  GraphQLConfig.refreshToken = token.refreshToken;
}
