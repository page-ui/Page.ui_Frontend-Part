import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/features/auth/presentation/views/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static String routeName = "SplashView";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextPage();
    });
  }

  void _navigateToNextPage() {
    Future.delayed(const Duration(milliseconds: 4500), () {
      AppRoutes.pushNamedAndRemoveAll(context, LoginView.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 130.0),
        child: Center(
          child: Column(
            children: [
              DefaultTextStyle(
                style: AppTextStyles.displayLarge!.copyWith(
                  color: AppColors.white,
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    WavyAnimatedText(
                      appName,
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              DefaultTextStyle(
                style: AppTextStyles.titleMedium!.copyWith(
                  color: AppColors.white,
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      "initializing page.ui....",
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
