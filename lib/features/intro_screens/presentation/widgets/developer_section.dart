import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developer_card.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developer_profile.dart';

class DeveloperSection extends StatelessWidget {
  final String title;
  final Color accent;
  final double titleFont;
  final double nameFont;
  final double repoFont;
  final List<DeveloperProfile> developers;

  const DeveloperSection({
    required this.title,
    required this.accent,
    required this.titleFont,
    required this.nameFont,
    required this.repoFont,
    required this.developers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.18),
            AppColors.black.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 20.w,
            runSpacing: 20.h,
            children: developers
                .map(
                  (developer) => DeveloperCard(
                    developer: developer,
                    accent: accent,
                    nameFont: nameFont,
                    repoFont: repoFont,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
