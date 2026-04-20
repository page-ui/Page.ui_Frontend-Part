import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/features/chat/domain/constants/message_types.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:pageui/features/chat/presentation/widgets/ui_frame/iframe_view.dart';

class UIFrameBody extends StatelessWidget {
  const UIFrameBody({
    super.key,
    required this.isMobile,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  final bool isMobile;
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: isMobile ? 1 : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButtonIconForPanels(
                isLeftPanel: true,
                onPressed: onLeftButtonPressed,
              ),
              CustomButtonIconForPanels(
                isLeftPanel: false,
                onPressed: onRightButtonPressed,
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
            builder: (context, state) {
              final url = _latestAiRunUrl(state);
              if (url == null) {
                return const _EmptyUIPreview();
              }
              return IframeView(key: ValueKey(url), url: url);
            },
          ),
        ),
      ],
    );
  }

  String? _latestAiRunUrl(ChatMessagesState state) {
    if (state is! ChatMessagesLoaded) return null;

    MessageEntity? latest;
    for (final message in state.messages) {
      if (!isAiMessageType(message.type)) continue;
      final content = message.content.trim();
      if (content.isEmpty) continue;
      if (latest == null || message.createdAt.isAfter(latest.createdAt)) {
        latest = message;
      }
    }

    if (latest == null) return null;
    // final content = latest.content.trim();
    // if (content.startsWith('/'))
    return 'http://127.0.0.1/runs/a438eff8-006c-4a33-e83c-ed058546c35b/preview.html';
    // return content;
  }
}

class _EmptyUIPreview extends StatelessWidget {
  const _EmptyUIPreview();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web_rounded,
            size: 48,
            color: AppColors.primaryColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'UI Preview',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Generated UI will render here',
            style: TextStyle(
              color: AppColors.lightGray.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
