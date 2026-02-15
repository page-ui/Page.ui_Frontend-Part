import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> login(GraphQLClient client, String email, String password) async {
  final res = await client.mutate(
    MutationOptions(
      document: gql(loginMutation),
      variables: {'email': email, 'password': password},
    ),
  );
  final data = res.data?['login'];
  await _secure.write(key: 'accessToken', value: data['accessToken']);
  await _secure.write(key: 'refreshToken', value: data['refreshToken']);
}

const loginMutation = '''
mutation Login(\$email: String!, \$password: String!) {
  login(email: \$email, password: \$password) {
    accessToken
    refreshToken
    user { id email }
  }
}
''';

final _secure = FlutterSecureStorage();
final _httpLink = HttpLink('https://api.yourdomain.com/graphql');

AuthLink authLink = AuthLink(
  getToken: () async {
    final token = await _secure.read(key: 'accessToken');
    return token == null ? null : 'Bearer $token';
  },
);

final Link link = authLink.concat(_httpLink);

ValueNotifier<GraphQLClient> client() {
  final cache = GraphQLCache(store: InMemoryStore());
  return ValueNotifier(GraphQLClient(link: link, cache: cache));
}
