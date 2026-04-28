import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/footer_links_column.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        final medium = w >= 700 && w < 1100;

        final headFont = compact
            ? 96.sp
            : medium
            ? 56.sp
            : 24.sp;
        final bodyFont = compact
            ? 72.sp
            : medium
            ? 44.sp
            : 20.sp;
        final linkFont = compact
            ? 64.sp
            : medium
            ? 40.sp
            : 18.sp;
        final smallFont = compact
            ? 52.sp
            : medium
            ? 32.sp
            : 14.sp;
        final hPad = compact
            ? 80.w
            : medium
            ? 120.w
            : 200.w;

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
              compact
                  ? _buildCompactFooter(headFont, bodyFont, linkFont)
                  : _buildWideFooter(headFont, bodyFont, linkFont),

              SizedBox(height: 60.h),
              Divider(color: AppColors.white.withValues(alpha: 0.1)),
              SizedBox(height: 20.h),

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

  Widget _buildWideFooter(double headFont, double bodyFont, double linkFont) {
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
        const SizedBox(width: 12),
        Expanded(
          child: FooterLinksColumn(
            title: "Project",
            links: const ["Documentation", "GitHub"],
            titleFont: headFont,
            linkFont: linkFont,
          ),
        ),
        Expanded(
          child: FooterLinksColumn(
            title: "Company",
            links: const ["Developers", "Support"],
            titleFont: headFont,
            linkFont: linkFont,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactFooter(
    double headFont,
    double bodyFont,
    double linkFont,
  ) {
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
            Expanded(
              child: FooterLinksColumn(
                title: "Project",
                links: const ["Documentation", "GitHub"],
                titleFont: headFont,
                linkFont: linkFont,
              ),
            ),
            Expanded(
              child: FooterLinksColumn(
                title: "Company",
                links: const ["Developers", "Support"],
                titleFont: headFont,
                linkFont: linkFont,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
