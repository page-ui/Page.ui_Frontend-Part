import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel/history_panel_header.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel/history_search_text_field.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel/list_of_chat_rooms.dart';

class HistoryPanelBody extends StatefulWidget {
  const HistoryPanelBody({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  State<HistoryPanelBody> createState() => _HistoryPanelBodyState();
}

class _HistoryPanelBodyState extends State<HistoryPanelBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ChatHistoryCubit>().searchChats(query: query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          HistoryPanelHeader(widget: widget),
          const SizedBox(height: 8),
          Row(
            children: [
              BlocBuilder<ChatHomeCubit, ChatHomeState>(
                builder: (context, state) {
                  return AbsorbPointer(
                    absorbing: state is ChatHomeLoading,
                    child: IconButton(
                      onPressed: () async {
                        await context.read<ChatHomeCubit>().createChat(
                          name: 'New Chat',
                        );
                        await context.read<ChatHistoryCubit>().loadChats();
                      },
                      icon: Icon(AppIcons.plus),
                    ),
                  );
                },
              ),
              const SizedBox(width: 2),
              Expanded(
                child: HistorySearchTextField(
                  onSearch: _onSearchChanged,
                  searchController: _searchController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListOfChatRooms(
            searchController: _searchController,
            debounce: _debounce,
            onChatSelected: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
