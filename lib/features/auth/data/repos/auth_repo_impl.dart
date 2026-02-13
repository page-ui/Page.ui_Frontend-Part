import 'package:dartz/dartz.dart';
import 'package:pageui/core/errors/failure.dart';
import 'package:pageui/features/auth/data/model/user_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';
import 'package:pageui/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<Failure, UserModel>> login({required LoginParams param}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> signup({required SignupParams param}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> changePassword({required String newPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendCodeForForgetPassword({
    required String email,
  }) {
    // TODO: implement sendCodeForForgetPassword
    throw UnimplementedError();
  }
}
