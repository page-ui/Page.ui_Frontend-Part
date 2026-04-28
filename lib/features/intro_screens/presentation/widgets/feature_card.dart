import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double cardWidth;
  final double titleFont;
  final double bodyFont;
  final double iconSize;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.cardWidth,
    required this.titleFont,
    required this.bodyFont,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(40.w),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.white, size: iconSize),
                ),
                SizedBox(height: 30.h),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFont,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  description,
                  style: AppTextStyles.titleMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.6),
                    height: 1.5,
                    fontSize: bodyFont,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
