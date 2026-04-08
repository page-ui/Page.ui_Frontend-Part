import 'package:flutter/material.dart';

class LoadMessagesBuilder extends StatelessWidget {
  const LoadMessagesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(),
      // child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
      //   builder: (context, state) {
      //     final messages = state is ChatMessagesLoaded
      //         ? state.messages
      //         : const [];

      //     if (messages.isEmpty) {
      //       return Center(
      //         child: Text(
      //           'Messages will appear here',
      //           style: AppTextStyles.bodyLarge!.copyWith(
      //             color: AppColors.lightGray.withValues(alpha: 0.5),
      //             fontSize: 14,
      //           ),
      //         ),
      //       );
      //     }

      //     return ListView.builder(
      //       reverse: true,
      //       padding: const EdgeInsets.symmetric(vertical: 4),
      //       itemCount: messages.length,
      //       itemBuilder: (context, index) {
      //         final reversed = messages.length - 1 - index;
      //         return MessageBubble(message: messages[reversed]);
      //       },
      //     );
      //   },
      // ),
    );
  }
}
