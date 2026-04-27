import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/core/helpers/open_external_link.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        final medium = w >= 700 && w < 1100;

        final headFont = compact ? 96.sp : medium ? 56.sp : 24.sp;
        final bodyFont = compact ? 72.sp : medium ? 44.sp : 20.sp;
        final linkFont = compact ? 64.sp : medium ? 40.sp : 18.sp;
        final smallFont = compact ? 52.sp : medium ? 32.sp : 14.sp;
        final hPad = compact ? 80.w : medium ? 120.w : 200.w;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 80.h),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.5),
            border: Border(
              top: BorderSide(color: AppColors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            children: [
              // Main footer content
              compact
                  ? _buildCompactFooter(headFont, bodyFont, linkFont)
                  : _buildWideFooter(headFont, bodyFont, linkFont),

              SizedBox(height: 60.h),
              Divider(color: AppColors.white.withValues(alpha: 0.1)),
              SizedBox(height: 20.h),

              // Bottom bar
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20.w,
                runSpacing: 10.h,
                children: [
                  Text(
                    "© ${DateTime.now().year} Page.ui.",
                    style: AppTextStyles.labelMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.4),
                      fontSize: smallFont,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideFooter(
      double headFont, double bodyFont, double linkFont) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appName,
                style: AppTextStyles.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: headFont,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Empowering frontend developers to build visually coherent, original UI designs instantly.",
                style: AppTextStyles.titleMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.5),
                  fontSize: bodyFont,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _FooterLinksColumn(
            title: "Developers",
            links: const ["Documentation", "GitHub"],
            titleFont: headFont,
            linkFont: linkFont,
          ),
        ),
        Expanded(
          child: _FooterLinksColumn(
            title: "Company",
            links: const [ "Developers", "Support"],
            titleFont: headFont,
            linkFont: linkFont,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactFooter(
      double headFont, double bodyFont, double linkFont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appName,
          style: AppTextStyles.headlineMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: headFont,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Empowering frontend developers to build visually coherent, original UI designs instantly.",
          style: AppTextStyles.titleMedium?.copyWith(
            color: AppColors.white.withValues(alpha: 0.5),
            fontSize: bodyFont,
          ),
        ),
        SizedBox(height: 40.h),
        Wrap(
          spacing: 60.w,
          runSpacing: 40.h,
          children: [
            _FooterLinksColumn(
              title: "Platform",
              links: const ["Features", "Pricing", "Enterprise"],
              titleFont: headFont,
              linkFont: linkFont,
            ),
            _FooterLinksColumn(
              title: "Developers",
              links: const ["Documentation", "API Reference", "GitHub"],
              titleFont: headFont,
              linkFont: linkFont,
            ),
            _FooterLinksColumn(
              title: "Company",
              links: const ["About Us", "Contact", "Support"],
              titleFont: headFont,
              linkFont: linkFont,
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLinksColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  final double titleFont;
  final double linkFont;

  const _FooterLinksColumn({
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
