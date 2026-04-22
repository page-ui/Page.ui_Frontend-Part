import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key, required this.chat, this.onTap});

  final ChatEntity chat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.8),
            borderRadius: AppBorders.xxxs,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppBorders.xxxs,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4, right: 8),
                        child: Icon(
                          AppIcons.arrowForward,
                          size: 12,
                          color: AppColors.lightGray,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          chat.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.lightGray.withValues(alpha: 0.9),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatDateTime(chat.createdAt ?? DateTime.now()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period - ${dateTime.day}/${dateTime.month}/${dateTime.year.toString().substring(2)}';
  }
}
