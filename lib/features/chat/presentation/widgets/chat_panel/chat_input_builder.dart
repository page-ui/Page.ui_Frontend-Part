import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';
// PickFileCubit is provided by an ancestor (HomeViewBody) so input bar and
// landing page share the same picked-image state.
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_state.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_input_bar.dart';

class ChatInputBuilder extends StatefulWidget {
  const ChatInputBuilder({super.key});

  @override
  State<ChatInputBuilder> createState() => _ChatInputBuilderState();
}

class _ChatInputBuilderState extends State<ChatInputBuilder> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit.get<SendMessageCubit>(),
      child: BlocListener<SendMessageCubit, SendMessageState>(
        listener: (context, state) {
          final pickFileCubit = context.read<PickFileCubit>();

          if (state is SendMessageSuccess) {
            _controller.clear();
            _focusNode.requestFocus();

            if (pickFileCubit.isImagePicked) {
              pickFileCubit.removeImage();
            }

            final messagesState = context.read<ChatMessagesCubit>().state;
            if (messagesState is ChatMessagesLoaded) {
              context.read<ChatMessagesCubit>().markAwaitingAiResponse(
                chatId: messagesState.chatId,
              );
            }
          }

          if (state is SendMessageError) {
            showWebSnackBar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
            );
          }
        },
        child: BlocBuilder<SendMessageCubit, SendMessageState>(
          buildWhen: (prev, curr) {
            final wasSending = prev is SendMessageLoading;
            final isSending = curr is SendMessageLoading;
            return wasSending != isSending;
          },
          builder: (context, sendState) {
            final pickFileCubit = context.watch<PickFileCubit>();
            final messagesState = context
                .watch<ChatMessagesCubit>()
                .state;
            final isAwaitingAi =
                messagesState is ChatMessagesLoaded &&
                messagesState.isAwaitingAiResponse;
            final isSending =
                sendState is SendMessageLoading || isAwaitingAi;

            return ChatInputBar(
              controller: _controller,
              focusNode: _focusNode,
              isSending: isSending,
              hasSelectedImage: pickFileCubit.isImagePicked,
              onSend: () {
                final homeState = context.read<ChatHomeCubit>().state;
                final selectedChat = homeState.selectedChat;
                if (selectedChat == null) return;

                final message = _controller.text.trim();
                if (message.isEmpty && !pickFileCubit.isImagePicked) return;

                if (pickFileCubit.isImagePicked) {
                  context.read<SendMessageCubit>().setImageData(
                    bytes: pickFileCubit.imageBytes!,
                    fileName: pickFileCubit.imageFileName!,
                    contentType: pickFileCubit.imageContentType!,
                  );
                }

                context.read<SendMessageCubit>().sendMessage(
                  params: SendMessageParams(
                    chatId: selectedChat.id,
                    content: message.isEmpty ? 'image' : message,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
