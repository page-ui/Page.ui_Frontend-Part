import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/core/custom_widget/custom_divider.dart';
import 'package:pageui/core/custom_widget/dots.dart';
import 'package:pageui/core/custom_widget/logo_widget.dart';
import 'package:pageui/core/custom_widget/main_background.dart';

class CustomAuthScreenTheme extends StatelessWidget {
  const CustomAuthScreenTheme({
    super.key,
    required this.child,
    required this.viewTitle,
  });

  final Widget child;
  final String viewTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MainBackground(),
        Positioned.fill(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth;

                      if (constraints.maxWidth > 1200) {
                        maxWidth = 500;
                      } else if (constraints.maxWidth > 800) {
                        maxWidth = 500;
                      } else {
                        maxWidth = constraints.maxWidth * 0.62;
                      }

                      return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green.withOpacity(0.6),
                                blurRadius: 26,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: AppBorders.xxxxs,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            color: AppColors.mainBackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Dots(),
                                CustomDivider(),
                                const SizedBox(height: 8),
                                Text(
                                  viewTitle,
                                  style: AppTextStyles.titleLarge!.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                child,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
