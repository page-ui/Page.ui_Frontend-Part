import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/forget_pasword_view_body.dart';

class ForgetPaswordView extends StatelessWidget {
  const ForgetPaswordView({super.key});
  static String routeName = "ForgetPaswordView";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomAuthScreenTheme(
        viewTitle: 'Forget Password?',
        child: ForgetPaswordViewBody(),
      ),
    );
  }
}
