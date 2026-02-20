import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/views/forget_pasword_view.dart';
import 'package:pageui/features/auth/presentation/views/login_view.dart';
import 'package:pageui/features/auth/presentation/views/register_view.dart';
import 'package:pageui/features/chat/presentation/views/home_view.dart';
import 'package:pageui/features/intro_screens/presentation/views/splash_view.dart';

sealed class AppRoutes {
  const AppRoutes();

  // Pop current page
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  // Push named route (updates browser URL)
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  // Push named route and remove all previous routes
  static Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    BuildContext context,
    String newRouteName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      newRouteName,
      (_) => false,
      arguments: arguments,
    );
  }

  // Convenience methods
  static Future<void> pushRegisterView(BuildContext context) =>
      pushNamed(context, RegisterView.routeName);

  static Future<void> pushLoginView(BuildContext context) =>
      pushNamedAndRemoveAll(context, LoginView.routeName);

  static Future<void> pushHomeView(BuildContext context) =>
      pushNamedAndRemoveAll(context, HomeView.routeName);

  static Future<void> pushForgetPasswordView(BuildContext context) =>
      pushNamed(context, ForgetPaswordView.routeName);

  // Named routes map
  static final Map<String, Widget Function(BuildContext, Object?)> routes = {
    LoginView.routeName: (_, __) => const LoginView(),
    SplashView.routeName: (_, __) => const SplashView(),
    RegisterView.routeName: (_, __) => const RegisterView(),
    ForgetPaswordView.routeName: (_, __) => const ForgetPaswordView(),
    HomeView.routeName: (_, __) => const HomeView(),
  };

  // onGenerateRoute for MaterialApp
  static Route<dynamic>? Function(RouteSettings) onGenerateRoute =
      (RouteSettings settings) {
        final builder =
            routes[settings.name] ??
            (_, __) =>
                const Scaffold(body: Center(child: Text('Page not found')));

        return MaterialPageRoute(
          builder: (context) => builder(context, settings.arguments),
          settings: settings,
        );
      };
}
