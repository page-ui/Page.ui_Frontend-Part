import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/config/themes/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class CustomButtonIconForPanels extends StatelessWidget {
  const CustomButtonIconForPanels({
    super.key,
    required this.onPressed,
    required this.isLeftPanel,
  });

  final void Function()? onPressed;
  final bool isLeftPanel;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
        icon: Icon(
          isLeftPanel ? AppIcons.arrowForward : AppIcons.arrowBackward,
          color: AppColors.grey,
          size: 12,
        ),
      ),
    );
  }
}
