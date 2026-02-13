import 'package:pageui/features/auth/data/model/user_model.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';

abstract class AuthDataSource {
  Future<UserModel> login({required LoginParams params});
  Future<UserModel> signup({required SignupParams params});
  Future<String> sendCodeForForgetPassword({required String email});
  Future<void> changePassword({required String newPassword});
}

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<UserModel> login({required LoginParams params}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signup({required SignupParams params}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword({required String newPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<String> sendCodeForForgetPassword({required String email}) {
    // TODO: implement sendCodeForForgetPassword
    throw UnimplementedError();
  }
}
