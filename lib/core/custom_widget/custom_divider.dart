import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.primaryColor.withValues(alpha: 0.3));
  }
}
