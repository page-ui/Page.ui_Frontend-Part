import 'package:flutter/material.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class SignpForm extends StatelessWidget {
  const SignpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "UserName"),
          SizedBox(height: 4),
          AuthTextFormField(
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),

          SizedBox(height: 16),

          customRowAuth(hint: "Email"),
          SizedBox(height: 4),
          AuthTextFormField(
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),

          SizedBox(height: 16),

          customRowAuth(hint: "Password"),
          SizedBox(height: 4),
          PasswordTextFormField(onChanged: (value) {}),

          SizedBox(height: 16),

          customRowAuth(hint: "Confirm Password"),
          SizedBox(height: 4),
          PasswordTextFormField(onChanged: (value) {}),

          SizedBox(height: 6),

          HaveAnAccountWidget(),

          SizedBox(height: 20),

          Center(
            child: CustomButton(title: "Register", onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
