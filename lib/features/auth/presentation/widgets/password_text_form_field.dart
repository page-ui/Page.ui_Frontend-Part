import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

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
        validator: (value) {
          // TODO: write the validator
          // if (value == null || value.isEmpty) {
          //   return 'this field is required';
          // }
          // return null;
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              isSecure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.darkSurface,
            ),
            iconSize: 20,
            onPressed: () {
              setState(() {
                isSecure = !isSecure;
              });
            },
          ),
          labelText: "Password",

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
