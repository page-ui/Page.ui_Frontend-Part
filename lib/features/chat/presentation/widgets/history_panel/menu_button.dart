import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.onRename,
    required this.onDelete,
    required this.isSelected,
  });

  final VoidCallback onRename;
  final VoidCallback onDelete;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected
        ? AppColors.white
        : AppColors.lightGray.withValues(alpha: 0.8);

    return SizedBox(
      height: 24,
      width: 24,
      child: PopupMenuButton<String>(
        tooltip: 'More',
        padding: EdgeInsets.zero,
        color: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.xxxxs,
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.3)),
        ),
        icon: Icon(Icons.more_vert, size: 18, color: iconColor),
        onSelected: (value) {
          if (value == 'rename') {
            onRename();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem<String>(
            value: 'rename',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 16, color: AppColors.white),
                SizedBox(width: 8),
                Text(
                  'Rename',
                  style: TextStyle(color: AppColors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 16, color: AppColors.red),
                SizedBox(width: 8),
                Text(
                  'Delete',
                  style: TextStyle(color: AppColors.red, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
