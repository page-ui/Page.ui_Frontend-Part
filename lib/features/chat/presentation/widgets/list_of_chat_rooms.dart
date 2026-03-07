import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_state.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_room.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_rooms_loading_indecators.dart';
import 'package:pageui/features/chat/presentation/widgets/panel_scrollbar.dart';

class ListOfChatRooms extends StatefulWidget {
  const ListOfChatRooms({
    super.key,
    required this.searchController,
    this.debounce,
  });
  final TextEditingController searchController;
  final Timer? debounce;
  @override
  State<ListOfChatRooms> createState() => _ListOfChatRoomsState();
}

class _ListOfChatRoomsState extends State<ListOfChatRooms> {
  final _scrollController = ScrollController();

  void _onChatSelected(ChatEntity chat) {
    context.read<ChatHomeCubit>().selectChat(chat: chat);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.searchController.dispose();
    widget.debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<ChatHistoryCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
        builder: (context, state) {
          if (state is ChatHistoryLoading) {
            return ChatRoomsLoadingIndecators();
          }

          if (state is ChatHistoryError) {
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

          if (state is ChatHistoryLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Text(
                  'No chats yet',
                  style: TextStyle(
                    color: AppColors.lightGray.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              );
            }

            return PanelScrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(right: 12),
                itemCount: state.chats.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.chats.length) {
                    return ChatRoomsLoadingIndecators();
                  }
                  return ChatRoom(
                    chat: state.chats[index],
                    onTap: () => _onChatSelected(state.chats[index]),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
