import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/config/themes/app_icons.dart';
import 'package:page_ui/config/themes/app_text_style.dart';
import 'package:page_ui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:flutter/material.dart';

class ChatPanelHeader extends StatelessWidget {
  const ChatPanelHeader({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.arrowForward, size: 12, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              "Chat Prompt",
              style: AppTextStyles.bodyLarge!.copyWith(
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        CustomButtonIconForPanels(isLeftPanel: true, onPressed: onPressed),
      ],
    );
  }
}
