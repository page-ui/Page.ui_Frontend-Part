import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';

part 'email_verfication_state.dart';

class EmailVerficationCubit extends Cubit<EmailVerficationState> {
  EmailVerficationCubit(this.authRepoImpl) : super(EmailVerficationInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> verifyResetCode({
    required VerifyResetCodeParams params,
    required String password,
  }) async {
    emit(EmailVerficationLoading());
    final result = await authRepoImpl.emailVerfication(params: params);
    result.fold(
      (failure) {
        emit(EmailVerficationFailure(message: failure.message));
      },
      (res) async {
        final login = await authRepoImpl.login(
          param: LoginParams(email: params.email, password: password),
        );
        login.fold(
          (failure) {
            emit(EmailVerficationFailure(message: failure.message));
          },
          (user) {
            emit(EmailVerficationSuccess());
          },
        );
      },
    );
  }

  Future<void> resendTheVerficationCode({required String email}) async {
    emit(EmailVerficationLoading());
    final result = await authRepoImpl.resendVerficationCode(email: email);
    result.fold(
      (l) {
        emit(EmailVerficationFailure(message: l.message));
      },
      (r) {
        emit(ResendTheCodeSuccess());
      },
    );
  }
}
