import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/helpers/open_external_link.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developer_profile.dart';

class DeveloperCard extends StatelessWidget {
  final DeveloperProfile developer;
  final Color accent;
  final double nameFont;
  final double repoFont;

  const DeveloperCard({
    required this.developer,
    required this.accent,
    required this.nameFont,
    required this.repoFont,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 520),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mainBackgroundColor.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            developer.name,
            style: AppTextStyles.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),
          TextButton(
            onPressed: () => openExternalLink(developer.repoUrl),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              developer.repoUrl,
              style: AppTextStyles.bodySmall?.copyWith(
                color: accent,
                decoration: TextDecoration.underline,
                decorationColor: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
