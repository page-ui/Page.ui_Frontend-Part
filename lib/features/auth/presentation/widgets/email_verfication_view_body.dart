import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';
import 'package:pageui/features/auth/presentation/controllers/email_verfication_cubit/email_verfication_cubit.dart';
import 'package:pageui/features/auth/presentation/views/email_verfication_view.dart';
import 'package:pageui/features/auth/presentation/widgets/o_t_p_code_verfication_for_the_view.dart';

class EmailVerficationViewBody extends StatelessWidget {
  const EmailVerficationViewBody({
    super.key,
    required this.widget,
    required this.onChangeLoadingValue,
  });
  final void Function(bool)? onChangeLoadingValue;

  final EmailVerficationView widget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerificationCubit(getit.get<AuthRepoImpl>()),
      child: Builder(
        builder: (context) {
          return EmailVerficationForm(
            param: widget.param,
            onChangeLoadingValue: onChangeLoadingValue,
            onPressed: (VerifyResetCodeParams p1) {
              context.read<EmailVerificationCubit>().verifyResetCode(
                params: VerifyResetCodeParams(email: p1.email, code: p1.code),
                password: widget.param.password,
              );
            },
          );
        },
      ),
    );
  }
}
