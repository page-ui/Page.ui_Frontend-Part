import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/config/routes/on_generate_routes.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:page_ui/features/chat/presentation/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = "HomeView";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppRoutes.goLanding(context);
      },
      child: BlocProvider(
        create: (_) => getit.get<ChatHomeCubit>(),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: HomeViewBody(),
        ),
      ),
    );
  }
}
