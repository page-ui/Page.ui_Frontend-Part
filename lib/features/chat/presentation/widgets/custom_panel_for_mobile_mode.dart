import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/core/constants/borders.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
        PointerInterceptor(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        Positioned(
          left: isRight ? null : 0,
          right: isRight ? 0 : null,
          top: 0,
          bottom: 0,
          child: PointerInterceptor(
            child: Container(
              width: width,
              margin: EdgeInsets.only(
                top: 28,
                bottom: 20,
                left: isRight ? 0 : 20,
                right: isRight ? 20 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: AppBorders.xxxxs,
                shape: BoxShape.rectangle,
                color: AppColors.anotherGray.withValues(alpha: 0.6),
                border: Border.all(color: AppColors.darkGrey, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: ColoredBox(color: AppColors.transparent, child: panel),
            ),
          ),
        ),
      ],
    );
  }
}
