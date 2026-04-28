import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';

class ReadDocsButton extends StatelessWidget {
  const ReadDocsButton({
    super.key,
    required this.btnFont,
  });

  final double btnFont;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: BorderSide(
          color: AppColors.white.withValues(alpha: 0.3),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 50.w,
          vertical: 20.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        "Read the Docs",
        style: AppTextStyles.titleLarge?.copyWith(
          color: AppColors.white,
          fontSize: btnFont,
        ),
      ),
    );
  }
}
