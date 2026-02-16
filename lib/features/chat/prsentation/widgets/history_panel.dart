import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: const Center(
        child: Text("LEFT", style: TextStyle(color: AppColors.white)),
      ),
    );
  }
}
