import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key,});
  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKeyPasswordReset = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyPasswordReset,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "New Password"),
          const SizedBox(height: 4),
          PasswordTextFormField(controller: _passwordController),
          const SizedBox(height: 16),
          customRowAuth(hint: "Confirm Password"),
          const SizedBox(height: 4),
          PasswordTextFormField(controller: _confirmPasswordController),
          const SizedBox(height: 20),
          CustomButton(
            title: 'Reset Password',
            onPressed: () {
              if (formKeyPasswordReset.currentState!.validate()) {
                if (_confirmPasswordController.text ==
                    _passwordController.text) {
                  FocusScope.of(context).unfocus();
                  showWebSnackBar(
                    context: context,
                    message: 'Password Reset Successfully.',
                  );
                  formKeyPasswordReset.currentState!.reset();
                  AppRoutes.pop(context);
                } else {
                  showWebSnackBar(
                    context: context,
                    message: "Password and Confirm Password must be same",
                    backgroundColor: AppColors.red,
                    textColor: AppColors.white,
                  );
                }
              } else {
                setState(() {
                  autovalidateMode = AutovalidateMode.always;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
