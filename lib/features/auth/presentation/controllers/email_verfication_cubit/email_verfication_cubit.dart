import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';

part 'email_verfication_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerficationState> {
  EmailVerificationCubit(this.authRepoImpl) : super(EmailVerficationInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> verifyResetCode({
    required VerifyResetCodeParams params,
    required String password,
  }) async {
    emit(EmailVerificationLoading());
    final result = await authRepoImpl.emailVerfication(params: params);
    await result.fold(
      (failure) {
        emit(EmailVerificationFailure(message: failure.message));
      },
      (res) async {
        final login = await authRepoImpl.login(
          param: LoginParams(email: params.email, password: password),
        );
        login.fold(
          (failure) {
            emit(EmailVerificationFailure(message: failure.message));
          },
          (user) {
            emit(EmailVerificationnSuccess());
          },
        );
      },
    );
  }

  Future<void> resendTheVerficationCode({required String email}) async {
    emit(EmailVerificationLoading());
    final result = await authRepoImpl.resendVerficationCode(email: email);
    result.fold(
      (l) {
        emit(EmailVerificationFailure(message: l.message));
      },
      (r) {
        emit(ResendTheCodeSuccess());
      },
    );
  }
}
