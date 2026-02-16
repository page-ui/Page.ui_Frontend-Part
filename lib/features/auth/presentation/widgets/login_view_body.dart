import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/login_view_form.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepoImpl: getit.get<AuthRepoImpl>()),
      child: LoginViewForm(),
    );
  }
}
