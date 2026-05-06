import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/features/auth/domain/repos/auth_repo.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final AuthRepo authRepo;

  DeleteAccountCubit(this.authRepo) : super(DeleteAccountInitial());

  Future<void> requestAccountDeletion() async {
    emit(DeleteAccountRequestLoading());
    final result = await authRepo.requestAccountDeletion();
    result.fold(
      (failure) =>
          emit(DeleteAccountRequestError(message: failure.message)),
      (_) => emit(DeleteAccountRequestSuccess()),
    );
  }

  Future<void> verifyDeletion(String code) async {
    emit(DeleteAccountVerifyLoading());
    final result = await authRepo.deleteAccount(code: code);
    result.fold(
      (failure) =>
          emit(DeleteAccountVerifyError(message: failure.message)),
      (_) => emit(DeleteAccountVerifySuccess()),
    );
  }
}
