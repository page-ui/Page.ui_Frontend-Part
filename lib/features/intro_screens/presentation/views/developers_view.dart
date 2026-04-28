import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developer_profile.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developer_section.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/developers_nav_bar.dart';

class DevelopersView extends StatelessWidget {
  static const String routeName = 'DevelopersView';

  const DevelopersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final compact = width < 700;
          final hPad = compact ? 20.w : 80.w;
          const bodyFont = 16.0;
          final cardTitleFont = compact ? 44.sp : 22.sp;
          final nameFont = compact ? 36.sp : 18.sp;
          final repoFont = compact ? 28.sp : 14.sp;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 120.h, hPad, 80.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developers',
                        style: AppTextStyles.headlineMedium?.copyWith(
                          color: AppColors.white,
                          // fontSize: titleFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Frontend, backend, and AI contributors with direct links to their GitHub profiles.',
                        style: AppTextStyles.titleMedium?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.6),
                          fontSize: bodyFont,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      DeveloperSection(
                        title: 'Frontend Developer',
                        accent: AppColors.lightCyan,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          DeveloperProfile(
                            name: 'Abdelrahman Khaled',
                            repoUrl: 'https://github.com/Polymath000',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      DeveloperSection(
                        title: 'Backend Developer',
                        accent: AppColors.greenAccent,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          DeveloperProfile(
                            name: 'Mohamed Alaa',
                            repoUrl: 'https://github.com/Anubisx404',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      DeveloperSection(
                        title: 'AI Developers',
                        accent: AppColors.amber,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          DeveloperProfile(
                            name: 'Abdelrahman Abdelnaser',
                            repoUrl: 'https://github.com/abdelrhmannaser845',
                          ),
                          DeveloperProfile(
                            name: 'Zeyad Alaa',
                            repoUrl: 'https://github.com/zeyad-alaa00',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DevelopersNavBar(),
              ),
            ],
          );
        },
      ),
    );
  }
}
