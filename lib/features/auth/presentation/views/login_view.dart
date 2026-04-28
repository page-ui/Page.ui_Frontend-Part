import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/core/helpers/custom_modal_progress_hud.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_auth_screen_theme.dart';
import 'package:pageui/features/auth/presentation/widgets/login_view_body.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String routeName = "LoginView";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppRoutes.pushLandingView(context);
      },
      child: Scaffold(
        body: CustomModalProgressHud(
          isLoading: isLoading,
          child: CustomAuthScreenTheme(
            viewTitle: 'Login',
            child: LoginViewBody(
              onChangeLoadingValue: (bool p1) {
                setState(() {
                  isLoading = p1;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
