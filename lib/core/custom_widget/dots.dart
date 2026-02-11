import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';

class Dots extends StatelessWidget {
  const Dots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
        SizedBox(width: 4),
        Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
        SizedBox(width: 4),
        Icon(AppIcons.dot, color: AppColors.darkGrey, size: 8),
      ],
    );
  }
}
