import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';

part 'email_verfication_state.dart';

class EmailVerficationCubit extends Cubit<EmailVerficationState> {
  EmailVerficationCubit(this.authRepoImpl) : super(EmailVerficationInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> verifyResetCode({required VerifyResetCodeParams params}) async {
    emit(EmailVerficationLoading());
    final result = await authRepoImpl.emailVerfication(params: params);
    result.fold(
      (failure) {
        emit(EmailVerficationFailure(message: failure.message));
      },
      (res) {
        emit(EmailVerficationSuccess());
      },
    );
  }
}
