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
    return TextFormField(
      obscureText: isSecure,
      obscuringCharacter: "*",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(isSecure ? Icons.visibility_off : Icons.visibility),
          iconSize: 20,
          onPressed: () {
            setState(() {
              isSecure = !isSecure;
            });
          },
        ),
        labelText: "Password",
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
