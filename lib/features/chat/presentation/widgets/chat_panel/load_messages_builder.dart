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
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final state = context.read<ChatMessagesCubit>().state;
    if (state is! ChatMessagesLoaded ||
        state.isLoadingMore ||
        !state.hasNextPage) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger load when user has scrolled 70% of the way to the top (older messages)
    if (currentScroll >= maxScroll * 0.7) {
      context.read<ChatMessagesCubit>().loadMoreMessages(chatId: state.chatId);
    }
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
              itemCount: messages.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                }
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
