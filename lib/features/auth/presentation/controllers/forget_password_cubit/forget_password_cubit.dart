import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit({required this.authRepoImpl})
    : super(ForgetPasswordInitial());
  final AuthRepoImpl authRepoImpl;
  Future<void> sendVerficationCode({required String email}) async {
    emit(ForgetPasswordLoading());
    final result = await authRepoImpl.sendCodeForForgetPassword(email: email);
    result.fold(
      (failure) {
        emit(ForgetPasswordFailure(message: failure.message));
      },
      (code) {
        emit(ForgetPasswordVerficationCodeSuccess(code: code));
      },
    );
  }

  Future<void> changePassword({required String newPassword}) async {
    emit(ForgetPasswordLoading());
    final result = await authRepoImpl.changePassword(newPassword: newPassword);
    result.fold(
      (failure) {
        emit(ForgetPasswordFailure(message: failure.message));
      },
      (code) {
        emit(ForgetPasswordSuccess());
      },
    );
  }
}
