import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_state.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:pageui/features/chat/presentation/widgets/message_bubble.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(AppIcons.arrowForward, size: 12, color: AppColors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Chat Prompt",
                    style: AppTextStyles.bodyLarge!.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 70),
                  CustomButtonIconForPanels(
                    isLeftPanel: true,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<SendMessageCubit, SendMessageState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  );
                }

                final messages = switch (state) {
                  MessagesLoaded s => s.messages,
                  SendMessageError s => s.previousMessages,
                  _ => const [],
                };

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Send a message to start',
                      style: AppTextStyles.bodyLarge!.copyWith(
                        color: AppColors.lightGray.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final reversed = messages.length - 1 - index;
                    return MessageBubble(message: messages[reversed]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<SendMessageCubit, SendMessageState>(
            buildWhen: (prev, curr) {
              final wasSending = prev is MessagesLoaded && prev.isSending;
              final isSending = curr is MessagesLoaded && curr.isSending;
              return wasSending != isSending;
            },
            builder: (context, state) {
              final isSending = state is MessagesLoaded && state.isSending;
              return ChatInputBar(
                isSending: isSending,
                onSend: (message) {
                  final homeState = context.read<ChatHomeCubit>().state;
                  if (homeState is ChatHomeActive) {
                    context.read<SendMessageCubit>().sendMessage(
                      params: SendMessageParams(
                        chatId: homeState.chat.id,
                        content: message,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
