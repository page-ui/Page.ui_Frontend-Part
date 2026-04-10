import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static String routeName = "HomeView";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      
        create: (_) => getit.get<ChatHomeCubit>(),
      
      child: Scaffold(
        backgroundColor: AppColors.black.withValues(alpha: 0.8),
        extendBody: true,
        body: const HomeViewBody(),
      ),
    );
  }
}
