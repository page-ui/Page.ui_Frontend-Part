import 'package:Page.ui/config/routes/on_generate_routes.dart';
import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/config/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class DoNotHaveAnAccountWidget extends StatelessWidget {
  const DoNotHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodySmall!.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => AppRoutes.pushRegisterView(context),
          child: Text(
            "[ Register ]",
            style: AppTextStyles.bodySmall!.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
