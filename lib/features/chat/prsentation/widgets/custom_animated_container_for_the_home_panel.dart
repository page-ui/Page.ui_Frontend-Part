import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/prsentation/widgets/home_panel_on_closed.dart';

class CustomAnimatedContainerForTheHomePanel extends StatelessWidget {
  const CustomAnimatedContainerForTheHomePanel({
    super.key,
    required this.isOpen,
    required this.isLeft,
    this.onPressed,
    required this.width,
    required this.child,
  });
  final bool isOpen;
  final bool isLeft;
  final void Function()? onPressed;
  final double width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 750,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(isOpen ? 0 : 6),
      decoration: BoxDecoration(
        borderRadius: AppBorders.xxxxs,
        shape: BoxShape.rectangle,
        color: AppColors.anotherGray,
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.5),
            blurRadius: 26,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
          ),
        ],
        border: Border.all(color: AppColors.grey, width: 1),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isOpen ? width : 40,
      child: isOpen
          ? child
          : HomePanelOnClosed(isLeftPanel: isLeft, onPressed: onPressed),
    );
  }
}
