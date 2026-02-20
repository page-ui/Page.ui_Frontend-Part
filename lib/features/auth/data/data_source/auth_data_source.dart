import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/reset_password.dart';
import 'package:pageui/features/auth/domain/params/register_params.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';

abstract class AuthDataSource {
  Future<UserTokensModel> login({required LoginParams params});
  Future<bool> register({required RegisterParams params});
  Future<bool> forgotPasswordRequest({required String email});
  Future<bool> resetPassword({required ResetPasswordParams params});
  Future<UserTokensModel> refreshToken({required String refreshToken});
  Future<String> verifyResetCodeParams({required VerifyResetCodeParams params});
}

class AuthDataSourceImpl extends AuthDataSource {
  final GraphQLClient _client = GraphQLConfig.client.value;
  AuthDataSourceImpl();

  @override
  Future<UserTokensModel> login({required LoginParams params}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.loginMutation),
        variables: {
          'input': {'email': params.email, 'password': params.password},
        },
      ),
    );

    if (result.data == null ||
        !result.data!.containsKey('login') ||
        result.data!['login'] == null ||
        result.hasException) {
      throw Exception(
        'Login failed. Please check your credentials and try again.',
      );
    }

    return UserTokensModel.fromJson(result.data!['login']);
  }

  @override
  Future<bool> register({required RegisterParams params}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.registerMutation),
        variables: {
          'input': {
            'email': params.email,
            'password': params.password,
            'name': params.userName,
          },
        },
      ),
    );
    if (result.data == null ||
        !result.data!.containsKey('register') ||
        result.data!['register'] == null ||
        result.data!['register'] == false ||
        result.hasException) {
      throw Exception(
        "Register failed. Please try again later. maybe the email is already used.",
      );
    }

    return result.data!['register'];
  }

  @override
  Future<bool> forgotPasswordRequest({required String email}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.forgotPasswordRequestMutation),
        variables: {'email': email},
      ),
    );

    if (result.data == null ||
        !result.data!.containsKey('forgotPasswordRequest') ||
        result.data!['forgotPasswordRequest'] == null ||
        result.data!['forgotPasswordRequest'] == false ||
        result.hasException) {
      throw Exception("May be you write a wrong account.");
    }

    return result.data!['forgotPasswordRequest'];
  }

  @override
  Future<String> verifyResetCodeParams({
    required VerifyResetCodeParams params,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.verifyResetCodeMutation),
        variables: {'email': params.email, 'code': params.code},
      ),
    );
    if (result.data == null ||
        !result.data!.containsKey('verifyResetCode') ||
        result.data!['verifyResetCode'] == null ||
        result.data!['verifyResetCode'] == false ||
        result.hasException) {
      throw Exception(
        "There was a propblem, please make sure you're write the code correct, or resend the code.",
      );
    }
    return result.data!['verifyResetCode'];
  }

  @override
  Future<bool> resetPassword({required ResetPasswordParams params}) async {
    const String resetPasswordMutation = r'''
      mutation ResetPassword($input: ResetPasswordInput!) {
        resetPassword(input: $input)
      }
    ''';

    final result = await _client.mutate(
      MutationOptions(
        document: gql(resetPasswordMutation),
        variables: params.toJson(),
      ),
    );
    return result.data!['resetPassword'];
    // if (result.hasException) throw Exception("Failed to reset password");
  }

  @override
  Future<UserTokensModel> refreshToken({required String refreshToken}) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
