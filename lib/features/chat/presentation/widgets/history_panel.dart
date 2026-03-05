import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_state.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_room.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';

class HistoryPanel extends StatefulWidget {
  const HistoryPanel({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<ChatHistoryCubit>().loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ChatHistoryCubit>().searchChats(query: query);
    });
  }

  void _onChatSelected(ChatEntity chat) {
    context.read<ChatHomeCubit>().selectChat(chat: chat);
  }

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
                    "History Interface",
                    style: AppTextStyles.bodyLarge!.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  CustomButtonIconForPanels(
                    isLeftPanel: false,
                    onPressed: widget.onPressed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Search field
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: AppTextStyles.bodyMedium!.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Search chats...',
              hintStyle: AppTextStyles.bodyMedium!.copyWith(
                color: AppColors.lightGray.withValues(alpha: 0.4),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                AppIcons.search,
                size: 18,
                color: AppColors.lightGray.withValues(alpha: 0.5),
              ),
              filled: true,
              fillColor: AppColors.black.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.darkGrey.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.darkGrey.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                ),
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          // Chat list
          Expanded(
            child: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
              builder: (context, state) {
                if (state is ChatHistoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  );
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

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.chats.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.chats.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        );
                      }
                      return ChatRoom(
                        chat: state.chats[index],
                        onTap: () => _onChatSelected(state.chats[index]),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
