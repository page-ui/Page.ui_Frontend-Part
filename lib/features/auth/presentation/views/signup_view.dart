import 'package:flutter/material.dart';
import 'package:pageui/core/helpers/custom_modal_progress_hud.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/signup_view_body.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});
  static final routeName = "SignupView";

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomModalProgressHud(
        isLoading: isLoading,
        child: CustomAuthScreenTheme(
          viewTitle: 'Signup',
          child: SignupViewBody(
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
