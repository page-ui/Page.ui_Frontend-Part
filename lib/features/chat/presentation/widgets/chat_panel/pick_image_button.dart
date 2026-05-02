import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/config/themes/app_icons.dart';
import 'package:Page.ui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final image = await FilePicker.platform.pickFiles(
          withData: true,
          allowMultiple: false,
          type: FileType.image,
        );
        if (!context.mounted) return;
        context.read<PickFileCubit>().pickImage(imageFile: image);
      },
      icon: Icon(
        AppIcons.file,
        color: AppColors.lightGray.withValues(alpha: 0.6),
        size: 20,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
