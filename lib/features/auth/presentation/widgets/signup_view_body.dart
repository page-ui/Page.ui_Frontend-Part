import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/signp_form.dart';

class SignupViewBody extends StatelessWidget {
  const SignupViewBody({super.key, required this.onChangeLoadingValue});
  final void Function(bool)? onChangeLoadingValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(authRepoImpl: getit.get<AuthRepoImpl>()),
      child: SignpForm(onChangeLoadingValue: onChangeLoadingValue),
    );
  }
}
