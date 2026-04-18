import 'package:flutter/material.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';

class UIFrameBody extends StatelessWidget {
  const UIFrameBody({
    super.key,
    required this.isMobile,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  final bool isMobile;
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: isMobile ? 1 : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButtonIconForPanels(
                isLeftPanel: true,
                onPressed: onLeftButtonPressed,
              ),
              CustomButtonIconForPanels(
                isLeftPanel: false,
                onPressed: onRightButtonPressed,
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.web_rounded,
                  size: 48,
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'UI Preview',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Generated UI will render here',
                  style: TextStyle(
                    color: AppColors.lightGray.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
