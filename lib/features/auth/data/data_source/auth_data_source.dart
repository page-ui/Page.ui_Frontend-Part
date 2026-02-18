import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/database/api/queries.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/reset_password.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';

abstract class AuthDataSource {
  Future<UserTokensModel> login({required LoginParams params});
  Future<bool> register({required SignupParams params});
  Future<String> sendCodeForForgetPassword({required String email});
  Future<bool> resetPassword({required ResetPasswordParams params});
  Future<UserTokensModel> refreshToken({required String refreshToken});
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
  Future<bool> register({required SignupParams params}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(Queries.signupMutation),
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
        "Signup failed. Please try again later. maybe the email is already used.",
      );
    }

    return result.data!['register'];
  }

  @override
  Future<String> sendCodeForForgetPassword({required String email}) async {
    const String forgotPasswordMutation = r'''
      mutation ForgotPasswordRequest($email: String!) {
        forgotPasswordRequest(email: $email)
      }
    ''';

    final result = await _client.mutate(
      MutationOptions(
        document: gql(forgotPasswordMutation),
        variables: {'email': email},
      ),
    );

    if (result.hasException) throw Exception("Failed to send code");
    return result.data!['forgotPasswordRequest'];
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
