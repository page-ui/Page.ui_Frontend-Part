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
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.8),
            borderRadius: AppBorders.xxxs,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 3,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            AppIcons.arrowForward,
                            size: 12,
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: chat.name,
                        style: TextStyle(
                          color: AppColors.lightGray.withOpacity(0.9),
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _formatDateTime(chat.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
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
