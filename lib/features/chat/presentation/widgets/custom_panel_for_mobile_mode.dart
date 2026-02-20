import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class CustomPanelForMobileMode extends StatelessWidget {
  const CustomPanelForMobileMode({
    super.key,
    required this.width,
    required this.panel,
    required this.onClose,
    this.isRight = false,
  });
  final double width;
  final Widget panel;
  final VoidCallback onClose;
  final bool isRight;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            decoration: BoxDecoration(color: AppColors.black.withOpacity(0.6)),
          ),
        ),
        Positioned(
          left: isRight ? null : 0,
          right: isRight ? 0 : null,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: width,
            child: ColoredBox(color: AppColors.anotherGray, child: panel),
          ),
        ),
      ],
    );
  }
}
