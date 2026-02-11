import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/do_not_have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/forget_password_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class LoginViewForm extends StatefulWidget {
  LoginViewForm({super.key});

  @override
  State<LoginViewForm> createState() => _LoginViewFormState();
}

class _LoginViewFormState extends State<LoginViewForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String email;
  late String password;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "Email"),
          SizedBox(height: 4),
          AuthTextFormField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          customRowAuth(hint: "Password"),
          SizedBox(height: 4),
          PasswordTextFormField(
            controller: _passwordController,
            onChanged: (String value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: 6),
          DoNotHaveAnAccountWidget(),
          SizedBox(height: 8),
          ForgetPasswordWidget(),
          SizedBox(height: 20),
          Center(
            child: CustomButton(
              title: 'Login',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  // showWebSnackBar(
                  //   context: context,
                  //   message: '$email---$password',
                  // );
                } else {
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
