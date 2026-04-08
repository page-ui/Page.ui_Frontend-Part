import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_state.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/message_bubble.dart';

class LoadMessagesBuilder extends StatelessWidget {
  const LoadMessagesBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
