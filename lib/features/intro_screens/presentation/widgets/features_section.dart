import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        final medium = w >= 700 && w < 1100;

        final labelFont = compact
            ? 58.sp
            : medium
            ? 36.sp
            : 20.sp;
        final headFont = compact
            ? 130.sp
            : medium
            ? 85.sp
            : 48.sp;
        final titleFont = compact
            ? 96.sp
            : medium
            ? 56.sp
            : 28.sp;
        final bodyFont = compact
            ? 72.sp
            : medium
            ? 44.sp
            : 22.sp;
        final iconSize = compact
            ? 100.sp
            : medium
            ? 64.sp
            : 32.sp;
        final hPad = compact
            ? 80.w
            : medium
            ? 120.w
            : 200.w;

        final cardSpacing = 40.w;
        final availableW = w - hPad * 2;
        final double cardW;
        if (compact) {
          cardW = availableW;
        } else if (medium) {
          cardW = (availableW - cardSpacing) / 2;
        } else {
          cardW = (availableW - cardSpacing * 2) / 3;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 150.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Features",
                style: AppTextStyles.labelLarge?.copyWith(
                  color: AppColors.primaryColor,
                  letterSpacing: 2,
                  fontSize: labelFont,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Built for the frontend developer",
                style: AppTextStyles.displayMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: headFont,
                ),
              ),
              SizedBox(height: 80.h),
              Wrap(
                spacing: cardSpacing,
                runSpacing: 40.h,
                children: [
                  FeatureCard(
                    icon: Icons.lightbulb_outline,
                    title: "Beyond Rigid Templates",
                    description:
                        "Unlike traditional AI tools, we learn from real-world design patterns (like Pinterest) to encourage diversity and avoid repetitive, generic interfaces.",
                    cardWidth: cardW,
                    titleFont: titleFont,
                    bodyFont: bodyFont,
                    iconSize: iconSize,
                  ),
                  FeatureCard(
                    icon: Icons.code,
                    title: "Developer Centric",
                    description:
                        "A design support system for you. Translate abstract ideas into concrete UI outputs instantly, freeing you to focus on logic and state management.",
                    cardWidth: cardW,
                    titleFont: titleFont,
                    bodyFont: bodyFont,
                    iconSize: iconSize,
                  ),
                  FeatureCard(
                    icon: Icons.dashboard_customize,
                    title: "Originality & Adaptability",
                    description:
                        "Focuses on structural and aesthetic design principles to ensure every generated UI is unique, tailored to your intent, and easy to refine.",
                    cardWidth: cardW,
                    titleFont: titleFont,
                    bodyFont: bodyFont,
                    iconSize: iconSize,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
