import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class LoginViewForm extends StatelessWidget {
  const LoginViewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.center,
            child: Text(
              "Login",
              style: AppTextStyles.headlineSmall!.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Email",
            style: AppTextStyles.bodyMedium!.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 8),
          AuthTextFormField(hint: "Email"),
          SizedBox(height: 16),
          Text(
            "Password",
            style: AppTextStyles.bodyMedium!.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 8),
          PasswordTextFormField(),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () => AppRoutes.pushSignup(context),
            child: Text(
              "Create new account",
              style: AppTextStyles.bodySmall!.copyWith(
                color: AppColors.facebook,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(child: CustomButton()),
        ],
      ),
    );
  }
}
