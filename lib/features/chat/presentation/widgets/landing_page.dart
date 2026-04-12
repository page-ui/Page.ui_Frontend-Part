import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/image_preview_chat_input_bar.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/pick_image_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.onSend, this.errorMessage});

  final Function({required String content, String? attachmentUrl}) onSend;
  final String? errorMessage;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final content = _controller.text.trim();
    final pickFileCubit = context.read<PickFileCubit>();

    if (content.isEmpty && !pickFileCubit.isImagePicked) return;

    widget.onSend(
      content: content.isEmpty ? 'image' : content,
      attachmentUrl: null, // Will be handled by the caller or passed if already uploaded
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.4),
                    borderRadius: AppBorders.xxxxs,
                    border: Border.all(
                      color: AppColors.darkGrey.withValues(alpha: 0.5),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      const ImagePreviewChatInputBar(),
                      Row(
                        children: [
                          const PickImageButton(),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Type your prompt...',
                                hintStyle: TextStyle(
                                  color:
                                      AppColors.lightGray.withValues(alpha: 0.4),
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
                          _CreateChatButton(onPressed: _handleSend),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  widget.errorMessage!,
                  style: AppTextStyles.bodyMedium?.copyWith(
                    color: AppColors.lightRed,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
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
            onTap: widget.onPressed,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.send_rounded,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
