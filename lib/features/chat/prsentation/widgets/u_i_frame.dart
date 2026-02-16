import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class UIFrame extends StatelessWidget {
  const UIFrame({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.anotherGray,
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.black,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.white),
              onPressed: onLeftButtonPressed,
            ),
            title: Text(
              isMobile
                  ? "Mobile"
                  : isTablet
                  ? "Tablet"
                  : "Desktop",
              style: const TextStyle(color: AppColors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.grid_view, color: AppColors.white),
                onPressed: onRightButtonPressed,
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Main Content",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
