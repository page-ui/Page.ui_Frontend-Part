import 'package:flutter/material.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/do_not_have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class LoginViewForm extends StatelessWidget {
  const LoginViewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          customRowAuth(hint: "Email"),
          SizedBox(height: 4),
          AuthTextFormField(hint: "Email"),
          SizedBox(height: 16),
          customRowAuth(hint: "Password"),
          SizedBox(height: 4),
          PasswordTextFormField(),
          SizedBox(height: 4),
          DoNotHaveAnAccountWidget(),
          SizedBox(height: 20),
          Center(child: CustomButton()),
        ],
      ),
    );
  }
}
