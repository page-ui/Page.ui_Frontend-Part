import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/o_t_p_code_verfication_for_the_view.dart';

class EmailVerficationView extends StatelessWidget {
  const EmailVerficationView({super.key, required this.email});
  final String email;
  static String routeName = "EmailVerficationView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAuthScreenTheme(
        viewTitle: 'Email Verfication',
        child: OTPCodeVerficationForTheView(email: email),
      ),
    );
  }
}
