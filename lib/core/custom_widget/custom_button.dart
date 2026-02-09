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
        "Login",
        style: AppTextStyles.bodyLarge!.copyWith(color: AppColors.white),
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
          WidgetState.any: AppColors.anotherGray,
        }),
        enableFeedback: true,
        shape: WidgetStateProperty.fromMap({
          WidgetState.hovered: RoundedRectangleBorder(
            borderRadius: AppBorders.xxs,
            side: BorderSide(color: AppColors.black),
          ),
          WidgetState.any: RoundedRectangleBorder(
            borderRadius: AppBorders.xxs,
            side: BorderSide(color: AppColors.grey),
          ),
        }),
      ),
    );
  }
}
