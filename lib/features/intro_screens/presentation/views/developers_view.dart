import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/helpers/open_external_link.dart';
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
          final titleFont = compact ? 58.sp : 24.sp;
          final bodyFont = compact ? 34.sp : 16.sp;
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
                          fontSize: titleFont,
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
                      _DeveloperSection(
                        title: 'Frontend Developer',
                        accent: AppColors.lightCyan,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          _DeveloperProfile(
                            name: 'Abdelrahman Khaled',
                            repoUrl: 'https://github.com/Polymath000',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _DeveloperSection(
                        title: 'Backend Developer',
                        accent: AppColors.greenAccent,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          _DeveloperProfile(
                            name: 'Mohamed Alaa',
                            repoUrl: 'https://github.com/Anubisx404',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _DeveloperSection(
                        title: 'AI Developers',
                        accent: AppColors.amber,
                        titleFont: cardTitleFont,
                        nameFont: nameFont,
                        repoFont: repoFont,
                        developers: const [
                          _DeveloperProfile(
                            name: 'Abdelrahman Abdelnaser',
                            repoUrl: 'https://github.com/abdelrhmannaser845',
                          ),
                          _DeveloperProfile(
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

class _DeveloperSection extends StatelessWidget {
  final String title;
  final Color accent;
  final double titleFont;
  final double nameFont;
  final double repoFont;
  final List<_DeveloperProfile> developers;

  const _DeveloperSection({
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
            style: AppTextStyles.titleLarge?.copyWith(
              color: AppColors.white,
              fontSize: titleFont,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 20.w,
            runSpacing: 20.h,
            children: developers
                .map(
                  (developer) => _DeveloperCard(
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

class _DeveloperCard extends StatelessWidget {
  final _DeveloperProfile developer;
  final Color accent;
  final double nameFont;
  final double repoFont;

  const _DeveloperCard({
    required this.developer,
    required this.accent,
    required this.nameFont,
    required this.repoFont,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 520),
      padding: EdgeInsets.all(20.w),
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
            style: AppTextStyles.titleMedium?.copyWith(
              color: AppColors.white,
              fontSize: nameFont,
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
              style: AppTextStyles.bodyMedium?.copyWith(
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

class _DeveloperProfile {
  final String name;
  final String repoUrl;

  const _DeveloperProfile({
    required this.name,
    required this.repoUrl,
  });
}
