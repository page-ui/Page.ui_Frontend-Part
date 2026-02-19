import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_button_icon_for_panels.dart';

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
      child: Column(
        children: [
          SizedBox(height: 27),
          Visibility(
            visible: isMobile,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 19.0),
                  child: CustomButtonIconForPanels(
                    isLeftPanel: true,
                    onPressed: onLeftButtonPressed,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 19.0),
                  child: CustomButtonIconForPanels(
                    isLeftPanel: false,
                    onPressed: onRightButtonPressed,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "Main Content",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
