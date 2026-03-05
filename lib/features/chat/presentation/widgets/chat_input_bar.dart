import 'package:flutter/material.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/core/constants/borders.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.isSending,
  });

  final void Function(String message) onSend;
  final bool isSending;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.4),
        borderRadius: AppBorders.xxxxs,
        border: Border.all(
          color: AppColors.darkGrey.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.isSending ? null : () {},
            icon: Icon(
              AppIcons.file,
              color: AppColors.lightGray.withValues(alpha: 0.6),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.isSending,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type your prompt...',
                hintStyle: TextStyle(
                  color: AppColors.lightGray.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: widget.isSending
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : AppColors.primaryColor.withValues(alpha: 0.8),
              borderRadius: AppBorders.xxxxs,
            ),
            child: IconButton(
              onPressed: widget.isSending ? null : _handleSend,
              icon: widget.isSending
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              color: AppColors.white,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ],
      ),
    );
  }
}
