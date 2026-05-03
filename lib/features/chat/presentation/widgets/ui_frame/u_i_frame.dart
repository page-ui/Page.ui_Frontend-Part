import 'package:flutter/material.dart';
import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/core/constants/borders.dart';
import 'package:page_ui/features/chat/presentation/widgets/ui_frame/u_i_frame_body.dart';

class UIFrame extends StatelessWidget {
  const UIFrame({
    super.key,
    required this.onRightButtonPressed,
    this.wrapWithExpanded = true,
  });
  final void Function()? onRightButtonPressed;
  final bool wrapWithExpanded;

  @override
  Widget build(BuildContext context) {
    final frame = AnimatedContainer(
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: AppBorders.xxxxs,
        shape: BoxShape.rectangle,
        color: AppColors.anotherGray.withValues(alpha: 0.6),
        border: Border.all(color: AppColors.darkGrey, width: 0.5),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: UIFrameBody(onRightButtonPressed: onRightButtonPressed),
    );

    if (wrapWithExpanded) {
      return Expanded(child: frame);
    }

    return frame;
  }
}
