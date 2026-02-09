import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,

      child: TextFormField(
        cursorColor: AppColors.primaryColor,
        cursorOpacityAnimates: true,

        style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
        mouseCursor: SystemMouseCursors.click,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: AppTextStyles.bodyMedium!.copyWith(
            color: AppColors.darkSurface,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxs,
            borderSide: BorderSide(color: AppColors.darkSurface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxs,
            borderSide: BorderSide(color: AppColors.cyan),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxs,
            borderSide: BorderSide(color: AppColors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: AppBorders.xxxs,
            borderSide: BorderSide(color: AppColors.darkGrey),
          ),
        ),
      ),
    );
  }
}
