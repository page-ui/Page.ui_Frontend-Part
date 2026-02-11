import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String routeName = "LoginView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomAuthScreenTheme(viewTitle: 'Login',
    child: LoginViewBody()));
  }
}
