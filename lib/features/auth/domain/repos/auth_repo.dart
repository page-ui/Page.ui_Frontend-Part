import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/auth/data/model/user_tokens_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/reset_password.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserTokensModel>> login({required LoginParams param});
  Future<Either<Failure, bool>> register({required SignupParams param});
  Future<Either<Failure, String>> sendCodeForForgetPassword({
    required String email,
  });
  Future<Either<Failure, void>> changePassword({
    required ResetPasswordParams params,
  });
}
