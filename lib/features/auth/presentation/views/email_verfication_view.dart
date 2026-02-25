import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/helpers/custom_modal_progress_hud.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/presentation/controllers/email_verfication_cubit/email_verfication_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/email_verfication_view_body.dart';
import 'package:pageui/features/auth/presentation/widgets/o_t_p_code_verfication_for_the_view.dart';

class EmailVerficationView extends StatefulWidget {
  const EmailVerficationView({super.key, required this.param});
  final LoginParams param;
  static String routeName = "EmailVerficationView";

  @override
  State<EmailVerficationView> createState() => _EmailVerficationViewState();
}

class _EmailVerficationViewState extends State<EmailVerficationView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomModalProgressHud(
        isLoading: isLoading,

        child: CustomAuthScreenTheme(
          viewTitle: 'Email Verfication',
          child: EmailVerficationViewBody(
            widget: widget,
            onChangeLoadingValue: (bool p1) {
              setState(() {
                isLoading = p1;
              });
            },
          ),
        ),
      ),
    );
  }
}
