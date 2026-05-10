import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/config/routes/on_generate_routes.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/features/chat/domain/entities/chat_entity.dart';
import 'package:page_ui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:page_ui/features/chat/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.initialChat});

  static const String routeName = "HomeView";
  final ChatEntity? initialChat;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ChatHomeCubit _chatHomeCubit;

  @override
  void initState() {
    super.initState();
    _chatHomeCubit = getit.get<ChatHomeCubit>();
    if (widget.initialChat != null) {
      _chatHomeCubit.selectChat(chat: widget.initialChat!);
    }
  }

  @override
  void didUpdateWidget(HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialChat?.id != oldWidget.initialChat?.id) {
      if (widget.initialChat != null) {
        _chatHomeCubit.selectChat(chat: widget.initialChat!);
      } else {
        _chatHomeCubit.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppRoutes.goLanding(context);
      },
      child: BlocProvider.value(
        value: _chatHomeCubit,
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: HomeViewBody(),
        ),
      ),
    );
  }
}
