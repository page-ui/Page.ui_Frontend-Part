import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';

class ImagePreviewChatInputBar extends StatelessWidget {
  const ImagePreviewChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickFileCubit, PickFileState>(
      builder: (context, state) {
        if (state is! PickFileSuccess) {
          return const SizedBox();
        }

        final file = state.image.files.first;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: AppBorders.xxxxs,
          ),
          child: Row(
            children: [
              Icon(AppIcons.image, size: 16),
              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  file.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              GestureDetector(
                onTap: () => context.read<PickFileCubit>().removeImage(),
                child: Icon(AppIcons.close, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
