
import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/auth/data/data_source/auth_data_source.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/reset_password.dart';
import 'package:pageui/features/auth/domain/params/register_params.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';
import 'package:pageui/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthDataSource dataSource;
  final NetworkInfo networkInfo;
  AuthRepoImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserTokensModel>> login({
    required LoginParams param,
  }) async {
    try {
      if (!await networkInfo.isConnected!) {
        return Left(NetworkFailure.error());
      }
      final userTokensModel = await dataSource.login(params: param);
      await saveTokens(userTokensModel);
      return Right(userTokensModel);
    } on Exception catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure.fromServer(401));
      }
      return Left(
        ServerFailure(
          message: "Login failed. Please check your credentials and try again.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required RegisterParams param,
  }) async {
    try {
      if (!await networkInfo.isConnected!) {
        return Left(NetworkFailure.error());
      }
      final user = await dataSource.register(params: param);
      return Right(user);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure.fromServer(401));
      }
      return Left(
        ServerFailure(
          message:
              "Register failed. Please try again later. maybe the email is already used.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPasswordRequest({
    required String email,
  }) async {
    try {
      final response = await dataSource.forgotPasswordRequest(email: email);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: "May be you write a wrong account."));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetCode({
    required VerifyResetCodeParams params,
  }) async {
    try {
      final response = await dataSource.verifyResetCode(params: params);
      return Right(response);
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              "There was a propblem, please make sure you're write the code correct, or resend the code.",
        ),
      );
    }
  }


    @override
  Future<Either<Failure, bool>> emailVerfication({
    required VerifyResetCodeParams params,
  }) async {
    try {
      final response = await dataSource.emailVerfication(params: params);
      return Right(response);
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              "There was a propblem, please make sure you're write the code correct, or resend the code.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required ResetPasswordParams params,
  }) async {
    try {
      await dataSource.resetPassword(params: params);
      return Right(1);
    } catch (e) {
      return Left(
        ServerFailure(message: "Failed to change password. Please try again."),
      );
    }
  }

  @override
  Future<Either<Failure, UserTokensModel>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final res = await dataSource.refreshToken(refreshToken: refreshToken);
      await saveTokens(res);
      return Right(res);
    } catch (e) {
      return Left(
        ServerFailure(message: "There was an error. Please try again."),
      );
    }
  }
}
