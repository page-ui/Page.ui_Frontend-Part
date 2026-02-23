import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';

class RefreshTokenDataSource {
  final GraphQLClient _client = GraphQLConfig.client.value;
  Future<Either<Failure, UserTokensModel>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(Queries.refreshToken),
          variables: {"token": refreshToken},
        ),
      );
      final userTokensModel = result.data!['resetPassword'];
      saveTokens(userTokensModel);
      return Right(userTokensModel);
    } catch (e) {
      return Left(
        ServerFailure(message: "There was an error. Please try again."),
      );
    }

    // return result.data!['resetPassword'];
  }
}
