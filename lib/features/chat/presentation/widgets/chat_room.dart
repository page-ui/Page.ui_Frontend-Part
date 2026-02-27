import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/core/constants/borders.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    text:
                        "create a minimal dashboard with 3 cards: users, revenue, uptimef sadfsdfsdff addasdadssad asdf sdfd fsd fsdf",

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
                  "2:34 PM - 1/2/26",
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
    );
  }
}
