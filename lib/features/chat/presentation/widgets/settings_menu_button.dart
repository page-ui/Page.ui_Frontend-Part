import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/auth/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

enum _SettingsAction { signOut, deleteAccount }

class SettingsMenuButton extends StatelessWidget {
  const SettingsMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(getit.get<AuthRepoImpl>()),
      child: const _SettingsMenuButtonContent(),
    );
  }
}

class _SettingsMenuButtonContent extends StatelessWidget {
  const _SettingsMenuButtonContent();

  @override
  Widget build(BuildContext context) {
    Future<void> openActionsDialog() async {
      final action = await showDialog<_SettingsAction>(
        context: context,
        builder: (dialogContext) {
          return PointerInterceptor(
            child: SimpleDialog(
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.96),
              surfaceTintColor: AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorders.xxxs,
                side: BorderSide(
                  color: AppColors.darkGreen.withValues(alpha: 0.35),
                ),
              ),
              title: const Text(
                'Settings',
                style: TextStyle(color: AppColors.white),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(_SettingsAction.signOut),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        size: 16,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sign out',
                        style: TextStyle(color: AppColors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(_SettingsAction.deleteAccount),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete account',
                        style: TextStyle(color: AppColors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (!context.mounted) return;
      if (action == _SettingsAction.signOut) {
        await context.read<SettingsCubit>().signOut();
      } else if (action == _SettingsAction.deleteAccount) {
        // Just UI for now
      }
    }

    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          AppRoutes.pushLoginView(context);
        } else if (state is SettingsError) {
          showWebSnackBar(context: context, message: state.message);
        }
      },
      child: SizedBox(
        height: 24,
        width: 24,
        child: PointerInterceptor(
          child: IconButton(
            tooltip: 'Settings',
            padding: EdgeInsets.zero,
            onPressed: openActionsDialog,
            icon: const Icon(
              Icons.settings_outlined,
              size: 18,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
