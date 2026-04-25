import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_images.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/features/chat/presentation/widgets/settings_menu_button.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 45,
      backgroundColor: AppColors.anotherGray.withValues(alpha: 0.8),
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Image.asset(
              Assets.assetsImagesLogoWithoutBackground,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            appName,
            style: AppTextStyles.headlineSmall!.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: SettingsMenuButton(),
        ),
      ],
    );
  }
}
