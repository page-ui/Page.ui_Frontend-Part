import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "[Login]",
        style: AppTextStyles.bodyLarge!.copyWith(color: AppColors.green),
      ),
      onPressed: () {},
      style: ButtonStyle(
        maximumSize: WidgetStateProperty.fromMap({
          WidgetState.any: Size(double.infinity, 50),
        }),
        minimumSize: WidgetStateProperty.fromMap({
          WidgetState.any: Size(double.infinity, 50),
        }),
        backgroundColor: WidgetStateColor.fromMap({
          WidgetState.pressed: AppColors.spaceBlack,
          WidgetState.any: AppColors.transparent,
        }),
        enableFeedback: true,
        shape: WidgetStateProperty.fromMap({
          WidgetState.any: RoundedRectangleBorder(
            borderRadius: AppBorders.xxxs,
            side: BorderSide(color: AppColors.primaryColor),
          ),
        }),
      ),
    );
  }
}
