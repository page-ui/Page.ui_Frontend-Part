import 'package:Page.ui/config/themes/app_colors.dart';
import 'package:Page.ui/features/chat/presentation/widgets/name_and_the_logo.dart';
import 'package:Page.ui/features/chat/presentation/widgets/settings_menu_button.dart';
import 'package:flutter/material.dart';

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
      title: const NameAndTheLogo(),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: SettingsMenuButton(),
        ),
      ],
    );
  }
}
