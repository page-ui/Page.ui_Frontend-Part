import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/core/constants/borders.dart';
import 'package:Page.ui/core/enum/screen_type.dart';
import 'package:Page.ui/features/chat/presentation/widgets/ui_frame/u_i_frame_body.dart';
import 'package:flutter/material.dart';

class UIFrame extends StatelessWidget {
  const UIFrame({
    super.key,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: AppBorders.xxxxs,
        child: AnimatedContainer(
          margin: const EdgeInsets.only(
            top: 28,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: AppBorders.xxxxs,
            shape: BoxShape.rectangle,
            color: AppColors.anotherGray.withValues(alpha: 0.6),
            border: Border.all(color: AppColors.darkGrey, width: 0.5),
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: UIFrameBody(
            isMobile: context.isMobile,
            onLeftButtonPressed: onLeftButtonPressed,
            onRightButtonPressed: onRightButtonPressed,
          ),
        ),
      ),
    );
  }
}
