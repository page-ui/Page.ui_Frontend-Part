import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/presentation/widgets/name_and_the_logo.dart';

class LandingNavBar extends StatelessWidget {
  final ScrollController scrollController;

  const LandingNavBar({super.key, required this.scrollController});

  void _scrollTo(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 10.w : 20.w,
                vertical: 20.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainBackgroundColor.withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NameAndTheLogo(
                    onTap: () => _scrollTo(0),
                  ),
                  Row(
                    children: [
                      _NavBarItem(
                        title: "Features",
                        onTap: () => _scrollTo(1000.h),
                      ),
                      SizedBox(width: 40.w),
                      _NavBarItem(
                        title: "About",
                        onTap: () => _scrollTo(2200.h),
                      ),
                      SizedBox(width: 40.w),
                      _NavBarItem(
                        title: "Contact",
                        onTap: () => _scrollTo(3500.h),
                      ),
                    ],
                  ),

                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () =>
                            AppRoutes.pushLoginViewFromLanding(context),
                        child: Text(
                          "Log in",
                          style: AppTextStyles.titleMedium?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      if (!compact) SizedBox(width: 20.w),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Text(
          title,
          style: AppTextStyles.titleMedium?.copyWith(
            color: AppColors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
