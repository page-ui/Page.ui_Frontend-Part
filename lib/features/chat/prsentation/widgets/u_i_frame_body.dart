import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_button_icon_for_panels.dart';

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
        Center(
          child: Text("Main Content", style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
