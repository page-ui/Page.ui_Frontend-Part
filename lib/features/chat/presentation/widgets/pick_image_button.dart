import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_icons.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({super.key, this.onImagePicked});

  final void Function()? onImagePicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        FilePickerResult? image = await FilePicker.platform.pickFiles(
          withData: true,
          allowMultiple: false,
          type: FileType.image,
        );
        context.read<PickFileCubit>().pickImage(imageFile: image);
        if (image != null && onImagePicked != null) {
          onImagePicked!();
        }
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
