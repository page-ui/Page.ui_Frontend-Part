import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';

Future<void> onRenameChatRoom(BuildContext context, ChatEntity chat) async {
  final historyCubit = context.read<ChatHistoryCubit>();
  final homeCubit = context.read<ChatHomeCubit>();
  final controller = TextEditingController(text: chat.name);

  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      backgroundColor: const Color.fromARGB(255, 75, 99, 76),
      shadowColor: AppColors.darkGreen,
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.xxxs),
      title: const Text(
        'Rename chat',
        style: TextStyle(color: AppColors.white),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: AppColors.white),
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              hintText: 'Chat name',
              hintStyle: TextStyle(
                color: AppColors.lightGray.withValues(alpha: 0.5),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGray.withValues(alpha: 0.4),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
            ),
            onSubmitted: (value) =>
                Navigator.of(dialogContext).pop(value.trim()),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.lightGray),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(controller.text.trim()),
                child: const Text(
                  'Rename',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  controller.dispose();

  if (newName == null ||
      newName.isEmpty ||
      newName == chat.name ||
      !context.mounted) {
    return;
  }

  final result = await historyCubit.renameChat(chatId: chat.id, name: newName);
  if (!context.mounted) return;

  result.fold(
    (failure) => showWebSnackBar(
      context: context,
      message: failure.message,
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
    ),
    (renamed) {
      homeCubit.updateSelectedChat(
        chat: ChatEntity(
          id: chat.id,
          name: renamed.name,
          createdAt: chat.createdAt,
        ),
      );
    },
  );
}
