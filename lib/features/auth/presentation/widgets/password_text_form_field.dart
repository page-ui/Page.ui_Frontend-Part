import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/auth/presentation/widgets/password_validator.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({super.key});

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool isSecure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      child: TextFormField(
        style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
        cursorColor: AppColors.primaryColor,
        mouseCursor: SystemMouseCursors.click,
        obscureText: isSecure,
        obscuringCharacter: "*",
        validator: passwordValidator,
        decoration: InputDecoration(
          prefixIcon: Icon(AppIcons.arrowForward, size: 10),
          suffixIcon: IconButton(
            icon: Icon(
              isSecure ? AppIcons.visibilityOff : AppIcons.visibilityOn,
              color: AppColors.darkSurface,
            ),
            iconSize: 20,
            onPressed: () {
              setState(() {
                isSecure = !isSecure;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxxs,
            borderSide: BorderSide(color: AppColors.darkSurface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorders.xxxs,
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
