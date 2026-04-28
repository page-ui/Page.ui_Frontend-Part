import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/helpers/open_external_link.dart';

class FooterLinksColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  final double titleFont;
  final double linkFont;

  const FooterLinksColumn({
    required this.title,
    required this.links,
    required this.titleFont,
    required this.linkFont,
  });

  String? _linkTarget(String link) {
    switch (link) {
      case 'GitHub':
        return 'https://github.com/page-ui/codebase-demo-repository';
      case 'Support':
        return 'https://mail.google.com/mail/?view=cm&fs=1&to=pageui.service@gmail.com';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDevelopers = title == 'Developers';
    final titleLabel = Text(
      title,
      style: AppTextStyles.titleLarge?.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: titleFont,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isDevelopers
            ? TextButton(
                onPressed: () {
                  AppRoutes.pushDevelopersView(context);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: titleLabel,
              )
            : titleLabel,
        SizedBox(height: 20.h),
        ...links.map(
          (link) {
            final target = _linkTarget(link);

            final linkLabel = Text(
              link,
              style: AppTextStyles.titleMedium?.copyWith(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: linkFont,
              ),
            );

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: TextButton(
                onPressed: () {
                  if (link == 'Developers') {
                    AppRoutes.pushDevelopersView(context);
                    return;
                  }

                  if (target != null) {
                    openExternalLink(target);
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: linkLabel,
              ),
            );
          },
        ),
      ],
    );
  }
}
