import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/views/login_view.dart';
import 'package:pageui/features/auth/presentation/views/signup_view.dart';

sealed class AppRoutes {
  const AppRoutes();
  static void pop<T extends Object?>(
    final BuildContext context, [
    final T? result,
  ]) => Navigator.pop<T>(context);

  static Future<T?> pushNamed<T extends Object?>(
    final BuildContext context,
    final String routeName, {
    final Object? arguments,
  }) => Navigator.pushNamed<T>(context, routeName, arguments: arguments);

  static Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    final BuildContext context,
    final String newRouteName, {
    final Object? arguments,
  }) => Navigator.pushNamedAndRemoveUntil<T>(
    context,
    newRouteName,
    (_) => false,
    arguments: arguments,
  );
  static Future<void> pushSignup(BuildContext context) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const SignupView(),
        transitionsBuilder: (_, animation, __, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          final fade = Tween<double>(begin: 0, end: 1).animate(animation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }
}

Map<String, Widget Function(BuildContext, Object?)> _routes = {
  LoginView.routeName: (_, _) => const LoginView(),
  SignupView.routeName: (_, _) => const SignupView(),
};

Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (final settings) {
  final builder =
      _routes[settings.name] ??
      (_, _) => const Scaffold(body: Center(child: Text('Page not found')));
  return MaterialPageRoute(
    builder: (final context) => builder(context, settings.arguments),
    settings: settings,
  );
};
