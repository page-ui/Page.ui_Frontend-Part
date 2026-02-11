import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';

class HaveAnAccountWidget extends StatelessWidget {
  const HaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Have an account? ",
          style: AppTextStyles.bodySmall!.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => AppRoutes.pop(context),
          child: Text(
            "[Login]",
            style: AppTextStyles.bodySmall!.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
