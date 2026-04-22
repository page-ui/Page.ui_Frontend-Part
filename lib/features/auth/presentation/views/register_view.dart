import 'package:flutter/material.dart';
import 'package:pageui/core/helpers/custom_modal_progress_hud.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/register_view_body.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const routeName = "RegisterView";

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomModalProgressHud(
        isLoading: isLoading,
        child: CustomAuthScreenTheme(
          viewTitle: 'Register',
          child: RegisterViewBody(
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
