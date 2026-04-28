import 'package:flutter/material.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/presentation/views/email_verfication_view.dart';
import 'package:pageui/features/auth/presentation/views/forget_pasword_view.dart';
import 'package:pageui/features/auth/presentation/views/login_view.dart';
import 'package:pageui/features/auth/presentation/views/register_view.dart';
import 'package:pageui/features/auth/presentation/views/train_view.dart';
import 'package:pageui/features/chat/presentation/views/home_view.dart';
import 'package:pageui/features/intro_screens/presentation/views/developers_view.dart';
import 'package:pageui/features/intro_screens/presentation/views/landing_view.dart';
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

  static Future<void> pushSplashView(BuildContext context) =>
      pushNamed(context, SplashView.routeName);

  static Future<void> pushRegisterView(BuildContext context) =>
      pushNamed(context, RegisterView.routeName);

  static Future<void> pushLoginView(BuildContext context) =>
      pushNamedAndRemoveAll(context, LoginView.routeName);

  static Future<void> pushLoginViewFromLanding(BuildContext context) =>
      pushNamed(context, LoginView.routeName);

  static Future<void> pushHomeView(BuildContext context) =>
      pushNamedAndRemoveAll(context, HomeView.routeName);

  static Future<void> pushTrainView(BuildContext context) =>
      pushNamedAndRemoveAll(context, TrainView.routeName);

  static Future<void> pushLandingView(BuildContext context) =>
      pushNamedAndRemoveAll(context, LandingView.routeName);

  static Future<void> pushDevelopersView(BuildContext context) =>
      pushNamed(context, DevelopersView.routeName);

  static Future<void> pushForgetPasswordView(BuildContext context) =>
      pushNamed(context, ForgetPaswordView.routeName);
  static Future<void> pushEmailVerficationView(
    BuildContext context, {
    required LoginParams param,
  }) => pushNamed(context, EmailVerficationView.routeName, arguments: param);

  // Named routes map
  static final Map<String, Widget Function(BuildContext, Object?)> routes = {
    LandingView.routeName: (_, __) => const LandingView(),
    DevelopersView.routeName: (_, __) => const DevelopersView(),
    LoginView.routeName: (_, __) => const LoginView(),
    TrainView.routeName: (_, __) => const TrainView(),
    SplashView.routeName: (_, __) => const SplashView(),
    RegisterView.routeName: (_, __) => const RegisterView(),
    ForgetPaswordView.routeName: (_, __) => const ForgetPaswordView(),
    HomeView.routeName: (_, __) => const HomeView(),
    EmailVerficationView.routeName: (_, args) =>
        EmailVerficationView(param: args as LoginParams),
  };

  // onGenerateRoute for MaterialApp
  static Route<dynamic>? Function(RouteSettings) onGenerateRoute =
      (RouteSettings settings) {
        final builder =
            routes[settings.name] ??
            (_, __) =>
                const Scaffold(body: Center(child: Text('Page not found')));
        return customRouteBuilder(
          settings: settings,
          builder: (context) => builder(context, settings.arguments),
        );
      };
}

PageRouteBuilder<T> customRouteBuilder<T>({
  required Widget Function(BuildContext) builder,
  int duration = 500,
  RouteSettings? settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder: (context, _, __) => builder(context),
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1.8, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final fade = Tween<double>(begin: 0, end: 1).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
