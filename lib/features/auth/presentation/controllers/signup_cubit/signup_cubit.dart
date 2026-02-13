import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.authRepoImpl}) : super(SignupInitial());
  final AuthRepoImpl authRepoImpl;
  Future<void> signup({required SignupParams params}) async {
    emit(SignupLoading());
    final result = await authRepoImpl.signup(param: params);
    result.fold(
      (failure) {
        emit(SignupFailure(message: failure.message));
      },
      (user) {
        emit(SignupSuccess());
      },
    );
  }
}
