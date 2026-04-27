import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        final medium = w >= 700 && w < 1100;

        final heroFont = compact
            ? 180.sp
            : medium
            ? 130.sp
            : 90.sp;
        final bodyFont = compact
            ? 72.sp
            : medium
            ? 44.sp
            : 28.sp;
        final pillFont = compact
            ? 58.sp
            : medium
            ? 36.sp
            : 20.sp;
        final btnFont = compact
            ? 72.sp
            : medium
            ? 44.sp
            : 26.sp;
        final hPad = compact
            ? 80.w
            : medium
            ? 120.w
            : 200.w;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Column(
            children: [
              const SizedBox(height: 105),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryColor,
                      size: pillFont,
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        "Introducing Prompt-to-UI Generation",
                        style: AppTextStyles.labelLarge?.copyWith(
                          color: AppColors.white,
                          fontSize: pillFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                height: compact ? 280.h : 200.h,
                child: DefaultTextStyle(
                  style: AppTextStyles.displayLarge!.copyWith(
                    color: AppColors.white,
                    fontSize: heroFont,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: -2,
                  ),
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(milliseconds: 3000),
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Creativity without limits.\nPrompt to UI.",
                        speed: const Duration(milliseconds: 100),
                        textStyle: AppTextStyles.titleLarge!.copyWith(
                          fontSize: compact ? 120.sp : 70.sp,
                          color: AppColors.white,
                        ),
                        cursor: '|',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: compact ? w * 0.9 : 800.w,
                ),
                child: Text(
                  "Empowering frontend developers to build visually coherent, original UI designs instantly from natural language.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: bodyFont,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24.w,
                runSpacing: 20.h,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        AppRoutes.pushLoginViewFromLanding(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 20.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Start Building",
                          style: AppTextStyles.titleLarge?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: btnFont,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.arrow_forward,
                          size: btnFont,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
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
                  ),
                ],
              ),

              SizedBox(height: 80.h),

              Container(
                width: compact ? double.infinity : 1000.w,
                height: 300.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.white.withValues(alpha: 0.05),
                      AppColors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    left: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    right: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.code,
                        color: AppColors.white.withValues(alpha: 0.2),
                        size: compact ? 120.sp : 60.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "AI UI Generation Interface",
                        style: AppTextStyles.titleMedium?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.4),
                          fontSize: pillFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        );
      },
    );
  }
}
