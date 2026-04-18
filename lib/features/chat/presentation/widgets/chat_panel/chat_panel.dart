import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_input_builder.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_panel_header.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/load_messages_builder.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final selectedChat = context.read<ChatHomeCubit>().state.selectedChat;
    if (selectedChat == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (_) =>
          getit.get<ChatMessagesCubit>()..loadMessages(chatId: selectedChat.id),
      child: BlocListener<ChatHomeCubit, ChatHomeState>(
        listenWhen: (previous, current) =>
            previous.selectedChat?.id != current.selectedChat?.id &&
            current.selectedChat != null,
        listener: (context, state) {
          final chatId = state.selectedChat?.id;
          if (chatId == null) return;
          context.read<ChatMessagesCubit>().loadMessages(chatId: chatId);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ChatPanelHeader(onPressed: onPressed),
              const SizedBox(height: 8),
              const LoadMessagesBuilder(),
              const SizedBox(height: 8),
              const ChatInputBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
