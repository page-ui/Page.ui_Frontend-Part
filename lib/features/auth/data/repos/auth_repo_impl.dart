import 'package:dartz/dartz.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/auth/data/data_source/auth_data_source.dart';
import 'package:pageui/features/auth/data/model/user_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/reset_password.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';
import 'package:pageui/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthDataSource dataSource;
  final NetworkInfo networkInfo;
  AuthRepoImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserTokens>> login({
    required LoginParams param,
  }) async {
    try {
      if (!await networkInfo.isConnected!) {
        return Left(NetworkFailure.error());
      }
      final user = await dataSource.login(params: param);

      await SecureStorage.writeData(
        key: accessTokenKey,
        value: user.accessToken,
      );
      await SecureStorage.writeData(
        key: refreshTokenKey,
        value: user.refreshToken,
      );
      return Right(user);
    } on Exception catch (e) {
      print("auth Repo: ${e.toString()}");
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
  Future<Either<Failure, String>> sendCodeForForgetPassword({
    required String email,
  }) async {
    try {
      final response = await dataSource.sendCodeForForgetPassword(email: email);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: "Check your email connection."));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required ResetPasswordParams params,
  }) async {
    try {
      final response = await dataSource.resetPassword(params: params);
      return Right(1);
    } catch (e) {
      return Left(
        ServerFailure(message: "Failed to change password. Please try again."),
      );
    }
  }

  @override
  Future<Either<Failure, UserTokens>> signup({required SignupParams param}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  // Implement others...
}
