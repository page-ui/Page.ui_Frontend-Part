import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class LoginViewForm extends StatelessWidget {
  const LoginViewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
              SizedBox(width: 4),
              Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
              SizedBox(width: 4),
              Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
            ],
          ),
          Divider(color: AppColors.primaryColor.withOpacity(0.3)),
          SizedBox(height: 8),
          Align(
            alignment: AlignmentGeometry.center,
            child: Text(
              "Login",
              style: AppTextStyles.titleLarge!.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 8),
          Divider(color: AppColors.primaryColor.withOpacity(0.3)),
          SizedBox(height: 8),
          customRowAuth(hint: "Email"),
          SizedBox(height: 4),
          AuthTextFormField(hint: "Email"),
          SizedBox(height: 16),
          customRowAuth(hint: "Password"),
          SizedBox(height: 4),
          PasswordTextFormField(),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                "Don't have an account?  ",
                style: AppTextStyles.bodySmall!.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () => AppRoutes.pushSignup(context),
                child: Text(
                  "[Register]",
                  style: AppTextStyles.bodySmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(child: CustomButton()),
        ],
      ),
    );
  }
}
