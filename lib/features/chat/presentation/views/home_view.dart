import 'package:Page.ui/core/helpers/setup_service_locator_getit.dart';
import 'package:Page.ui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:Page.ui/features/chat/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static String routeName = "HomeView";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit.get<ChatHomeCubit>(),

      child: const Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: HomeViewBody(),
      ),
    );
  }
}
