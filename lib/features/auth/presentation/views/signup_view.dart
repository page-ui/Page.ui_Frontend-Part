import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static final routeName = "SignupView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAuthScreenTheme(viewTitle: 'Signup', child: Text("")),
    );
  }
}
