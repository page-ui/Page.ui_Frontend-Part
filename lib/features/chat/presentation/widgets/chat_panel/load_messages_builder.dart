import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/helpers/panel_scrollbar.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/message_bubble.dart';

class LoadMessagesBuilder extends StatefulWidget {
  const LoadMessagesBuilder({super.key});

  @override
  State<LoadMessagesBuilder> createState() => _LoadMessagesBuilderState();
}

class _LoadMessagesBuilderState extends State<LoadMessagesBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
        builder: (context, state) {
          if (state is ChatMessagesLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            );
          }

          if (state is ChatMessagesError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: AppColors.lightGray.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is! ChatMessagesLoaded) {
            return const SizedBox.shrink();
          }

          final messages = _sortMessages(state.messages);

          if (messages.isEmpty) {
            return Center(
              child: Text(
                'Messages will appear here',
                style: TextStyle(
                  color: AppColors.lightGray.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            );
          }

          return PanelScrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = messages.length - 1 - index;
                return MessageBubble(message: messages[reversedIndex]);
              },
            ),
          );
        },
      ),
    );
  }

  List<MessageEntity> _sortMessages(List<MessageEntity> messages) {
    return List<MessageEntity>.from(messages)
      ..sort((first, second) => first.createdAt.compareTo(second.createdAt));
  }
}
