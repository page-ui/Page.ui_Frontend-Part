import 'package:flutter/material.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.onCreateChat, this.errorMessage});

  final VoidCallback onCreateChat;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.chatBubble,
            size: 64,
            color: AppColors.primaryColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Page.ui',
            style: AppTextStyles.headlineSmall?.copyWith(
              color: AppColors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation to generate UI',
            style: AppTextStyles.bodyLarge?.copyWith(
              color: AppColors.lightGray.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          _CreateChatButton(onPressed: onCreateChat),
          if (errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: AppTextStyles.bodyMedium?.copyWith(
                color: AppColors.lightRed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _CreateChatButton extends StatefulWidget {
  const _CreateChatButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_CreateChatButton> createState() => _CreateChatButtonState();
}

class _CreateChatButtonState extends State<_CreateChatButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: AppBorders.xxxxs,
          border: Border.all(
            color: _isHovered
                ? AppColors.primaryColor
                : AppColors.primaryColor.withValues(alpha: 0.5),
            width: 1.2,
          ),
          color: _isHovered
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : AppColors.transparent,
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            borderRadius: AppBorders.xxxxs,
            onTap: () {
              widget.onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Create New Chat',
                    style: AppTextStyles.bodyLarge?.copyWith(
                      color: AppColors.primaryColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
