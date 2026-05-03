import 'package:flutter/material.dart';
import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/config/themes/app_text_style.dart';
import 'package:page_ui/core/enum/screen_type.dart';
import 'package:page_ui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';

class ChatPanelHeader extends StatelessWidget {
  const ChatPanelHeader({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Chat Prompt",
              style: AppTextStyles.bodyLarge!.copyWith(
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        CustomButtonIconForPanels(
          isLeftPanel: isMobile ? true : false,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
