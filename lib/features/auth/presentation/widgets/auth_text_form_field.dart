import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,

      child: TextFormField(
        cursorColor: AppColors.primaryColor,
        cursorOpacityAnimates: true,
        enableSuggestions: true,
        style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
        mouseCursor: SystemMouseCursors.click,
        decoration: InputDecoration(
          prefixIcon: Icon(AppIcons.arrowForward, size: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxxs,
            borderSide: BorderSide(color: AppColors.darkSurface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxxs,
            borderSide: BorderSide(color: AppColors.cyan),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxxs,
            borderSide: BorderSide(color: AppColors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: AppBorders.xxxxs,
            borderSide: BorderSide(color: AppColors.darkGrey),
          ),
        ),
      ),
    );
  }
}
