import 'package:Page.ui/core/errors/failure.dart';
import 'package:Page.ui/features/auth/data/model/user_tokens_model.dart';
import 'package:Page.ui/features/auth/domain/params/login_params.dart';
import 'package:Page.ui/features/auth/domain/params/register_params.dart';
import 'package:Page.ui/features/auth/domain/params/reset_password.dart';
import 'package:Page.ui/features/auth/domain/params/verify_reset_code_params.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserTokensModel>> login({required LoginParams param});
  Future<Either<Failure, bool>> register({required RegisterParams param});
  Future<Either<Failure, bool>> forgotPasswordRequest({required String email});
  Future<Either<Failure, void>> changePassword({
    required ResetPasswordParams params,
  });
  Future<Either<Failure, String>> verifyResetCode({
    required VerifyResetCodeParams params,
  });
  Future<Either<Failure, bool>> emailVerfication({
    required VerifyResetCodeParams params,
  });
  Future<Either<Failure, void>> resendVerficationCode({required String email});
  Future<Either<Failure, void>> signOut();
}
