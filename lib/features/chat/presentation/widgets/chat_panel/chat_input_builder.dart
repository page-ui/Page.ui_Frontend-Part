import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_state.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_input_bar.dart';

class ChatInputBuilder extends StatelessWidget {
  const ChatInputBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickFileCubit(),
      child: BlocConsumer<SendMessageCubit, SendMessageState>(
        listener: (context, state) {
          if (state is SendMessageError) {
            showWebSnackBar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
            );
          }
        },
        buildWhen: (prev, curr) {
          final wasSending = prev is MessagesLoaded && prev.isSending;
          final isSending = curr is MessagesLoaded && curr.isSending;
          return wasSending != isSending;
        },
        builder: (context, state) {
          final pickFileCubit = context.watch<PickFileCubit>();
          final isSending = state is MessagesLoaded && state.isSending;
          final sendMessageCubit = context.read<SendMessageCubit>();
          return ChatInputBar(
            isSending: isSending,
            hasSelectedImage: pickFileCubit.isImagePicked(),
            onSend: (message) {
              final homeState = context.read<ChatHomeCubit>().state;
              final selectedChat = homeState.selectedChat;
              if (selectedChat == null) return;

              if (pickFileCubit.imageBytes != null &&
                  pickFileCubit.imageFileName != null &&
                  pickFileCubit.imageContentType != null) {
                sendMessageCubit.setImageData(
                  bytes: pickFileCubit.imageBytes!,
                  fileName: pickFileCubit.imageFileName!,
                  contentType: pickFileCubit.imageContentType!,
                );

                sendMessageCubit
                    .sendMessage(
                      params: SendMessageParams(
                        chatId: selectedChat.id,
                        content: message.isEmpty ? 'image' : message,
                      ),
                    )
                    .then((success) {
                      if (success) {
                        pickFileCubit.removeImage();
                      }
                    });
                return;
              }

              sendMessageCubit.sendMessage(
                params: SendMessageParams(
                  chatId: selectedChat.id,
                  content: message,
                ),
              );
            },
            onImagePick: () {
              if (pickFileCubit.imageBytes == null ||
                  pickFileCubit.imageFileName == null ||
                  pickFileCubit.imageContentType == null) {
                return;
              }

              sendMessageCubit.setImageData(
                bytes: pickFileCubit.imageBytes!,
                fileName: pickFileCubit.imageFileName!,
                contentType: pickFileCubit.imageContentType!,
              );
            },
          );
        },
      ),
    );
  }
}
