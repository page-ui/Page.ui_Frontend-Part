import 'package:flutter/material.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_input_builder.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_panel_header.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/load_messages_builder.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ChatPanelHeader(onPressed: onPressed),
          const SizedBox(height: 8),
          LoadMessagesBuilder(),
          const SizedBox(height: 8),
          ChatInputBuilder(),
        ],
      ),
    );
  }
}
