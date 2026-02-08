import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: AppTextStyles.bodyMedium!.copyWith(color: AppColors.black),

        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.xxs,
          borderSide: BorderSide(color: AppColors.anotherGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.xxs,
          borderSide: BorderSide(color: AppColors.brown),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorders.xxs,
          borderSide: BorderSide(color: AppColors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: AppBorders.xxs,
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
      ),
    );
  }
}
