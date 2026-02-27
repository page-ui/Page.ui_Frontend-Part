import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_room.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(AppIcons.arrowForward, size: 12, color: AppColors.white),
                  SizedBox(width: 8),
                  Text(
                    "History Interface",
                    style: AppTextStyles.bodyLarge!.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  CustomButtonIconForPanels(
                    isLeftPanel: false,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          ChatRoom(),
          ChatRoom(),
          ChatRoom(),
          ChatRoom(),
        ],
      ),
    );
  }
}
