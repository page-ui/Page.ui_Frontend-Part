import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: const Center(
        child: Text("RIGHT", style: TextStyle(color: AppColors.white)),
      ),
    );
  }
}
