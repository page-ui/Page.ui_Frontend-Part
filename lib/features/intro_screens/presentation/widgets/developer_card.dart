import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/config/themes/app_text_style.dart';
import 'package:Page.ui/core/helpers/open_external_link.dart';
import 'package:Page.ui/features/intro_screens/presentation/widgets/developer_profile.dart';
import 'package:flutter/material.dart';

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
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 520),
      padding: const EdgeInsets.all(18),
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
              fontSize: nameFont,
            ),
          ),
          const SizedBox(height: 10),
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
                fontSize: repoFont,
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
