import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pageui/features/intro_screens/data/data_source/refresh_token_data_source.dart';

part 'refresh_token_state.dart';

class RefreshTokenCubit extends Cubit<RefreshTokenState> {
  RefreshTokenCubit(this.refreshTokenDataSource) : super(RefreshTokenInitial());
  final RefreshTokenDataSource refreshTokenDataSource;
  Future<void> refreshToken({required String refreshToken}) async {
    emit(RefreshTokenLoading());

    final result = await refreshTokenDataSource.refreshToken(
      refreshToken: refreshToken,
    );
    result.fold(
      (l) {
        emit(
          RefreshTokenFailure(message: "There was an error. Please try again."),
        );
      },
      (r) {
        emit(RefreshTokenSuccess());
      },
    );
  }
}
