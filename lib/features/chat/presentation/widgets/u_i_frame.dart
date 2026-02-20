import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/presentation/widgets/u_i_frame_body.dart';

class UIFrame extends StatelessWidget {
  const UIFrame({
    super.key,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.isMobile,
  });
  final bool isMobile;
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: 16, bottom: 10, left: 10, right: 10),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: AppBorders.xxxxs,
          shape: BoxShape.rectangle,
          color: AppColors.anotherGray,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
              blurStyle: BlurStyle.outer,
            ),
          ],
          border: Border.all(color: AppColors.grey, width: 1),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: UIFrameBody(
          isMobile: isMobile,
          onLeftButtonPressed: onLeftButtonPressed,
          onRightButtonPressed: onRightButtonPressed,
        ),
      ),
    );
  }
}
