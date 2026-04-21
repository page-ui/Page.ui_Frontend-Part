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
              final url = _activeAiRunUrl(state);
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

  /// Resolves the URL of the AI message that should be previewed.
  ///
  /// Prefers the explicitly selected message from the cubit so tapping
  /// "Preview" on an older message swaps the iframe. Falls back to the
  /// most recent AI message when nothing has been selected yet.
  String? _activeAiRunUrl(ChatMessagesState state) {
    if (state is! ChatMessagesLoaded) return null;

    final target =
        _selectedAiMessage(state) ?? _latestAiMessage(state.messages);
    if (target == null) return null;

    final content = target.content.trim();
    if (content.isEmpty) return null;
    if (content.startsWith('/')) return 'http://localhost$content';
    return content;
  }

  MessageEntity? _selectedAiMessage(ChatMessagesLoaded state) {
    final selectedId = state.selectedAiRunMessageId;
    if (selectedId == null) return null;
    for (final message in state.messages) {
      if (message.id != selectedId) continue;
      if (!isAiMessageType(message.type)) return null;
      return message.content.trim().isEmpty ? null : message;
    }
    return null;
  }

  MessageEntity? _latestAiMessage(List<MessageEntity> messages) {
    MessageEntity? latest;
    for (final message in messages) {
      if (!isAiMessageType(message.type)) continue;
      if (message.content.trim().isEmpty) continue;
      if (latest == null || message.createdAt.isAfter(latest.createdAt)) {
        latest = message;
      }
    }
    return latest;
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
