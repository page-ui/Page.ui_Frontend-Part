import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

enum _ChatRoomAction { rename, delete }

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

    Future<void> openActionsDialog() async {
      final action = await showDialog<_ChatRoomAction>(
        context: context,
        builder: (dialogContext) {
          return PointerInterceptor(
            child: SimpleDialog(
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.96),
              surfaceTintColor: AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorders.xxxs,
                side: BorderSide(
                  color: AppColors.darkGreen.withValues(alpha: 0.35),
                ),
              ),
              title: const Text(
                'Chat actions',
                style: TextStyle(color: AppColors.white),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(_ChatRoomAction.rename),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Rename',
                        style: TextStyle(color: AppColors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(_ChatRoomAction.delete),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: AppColors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (!context.mounted) return;
      if (action == _ChatRoomAction.rename) {
        onRename();
      } else if (action == _ChatRoomAction.delete) {
        onDelete();
      }
    }

    return SizedBox(
      height: 24,
      width: 24,
      child: PointerInterceptor(
        child: IconButton(
          tooltip: 'More',
          padding: EdgeInsets.zero,
          onPressed: openActionsDialog,
          icon: Icon(Icons.more_vert, size: 18, color: iconColor),
        ),
      ),
    );
  }
}
