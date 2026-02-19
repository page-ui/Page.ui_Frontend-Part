import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_button_icon_for_panels.dart';

class HomePanelOnClosed extends StatelessWidget {
  const HomePanelOnClosed({
    super.key,
    required this.onPressed,
    required this.isLeftPanel,
  });
  final void Function()? onPressed;
  final bool isLeftPanel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButtonIconForPanels(
          onPressed: onPressed,
          isLeftPanel: isLeftPanel,
        ),
        Spacer(flex: 1),
        RotatedBox(
          quarterTurns: isLeftPanel ? 3 : 1,
          child: Text(
            isLeftPanel ? "History" : "Chat",
            style: AppTextStyles.bodyLarge!.copyWith(
              letterSpacing: 8,
              color: AppColors.white,
            ),
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
