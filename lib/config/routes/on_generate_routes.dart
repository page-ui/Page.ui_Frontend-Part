import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
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

  static const String landingPath = '/';
  static const String splashPath = '/splash';
  static const String developersPath = '/developers';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgetPasswordPath = '/forget-password';
  static const String emailVerificationPath = '/email-verification';
  static const String homePath = '/home';
  static const String trainPath = '/train';

  static final GoRouter router = GoRouter(
    initialLocation: landingPath,
    routes: <RouteBase>[
      GoRoute(
        path: landingPath,
        name: LandingView.routeName,
        builder: (_, __) => const LandingView(),
      ),
      GoRoute(
        path: splashPath,
        name: SplashView.routeName,
        builder: (_, __) => const SplashView(),
      ),
      GoRoute(
        path: developersPath,
        name: DevelopersView.routeName,
        builder: (_, __) => const DevelopersView(),
      ),
      GoRoute(
        path: loginPath,
        name: LoginView.routeName,
        builder: (_, __) => const LoginView(),
      ),
      GoRoute(
        path: registerPath,
        name: RegisterView.routeName,
        builder: (_, __) => const RegisterView(),
      ),
      GoRoute(
        path: forgetPasswordPath,
        name: ForgetPaswordView.routeName,
        builder: (_, __) => const ForgetPaswordView(),
      ),
      GoRoute(
        path: emailVerificationPath,
        name: EmailVerficationView.routeName,
        builder: (_, state) =>
            EmailVerficationView(param: state.extra as LoginParams),
      ),
      GoRoute(
        path: homePath,
        name: HomeView.routeName,
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
        path: trainPath,
        name: TrainView.routeName,
        builder: (_, __) => const TrainView(),
      ),
    ],
  );

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop<T>(result);
  }

  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return context.pushNamed<T>(routeName, extra: arguments);
  }

  static Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    BuildContext context,
    String newRouteName, {
    Object? arguments,
  }) async {
    context.goNamed(newRouteName, extra: arguments);
    return null;
  }

  static Future<void> pushSplashView(BuildContext context) async =>
      pushNamed(context, SplashView.routeName);

  static Future<void> pushRegisterView(BuildContext context) async =>
      pushNamed(context, RegisterView.routeName);

  static Future<void> pushLoginView(BuildContext context) async =>
      pushNamedAndRemoveAll(context, LoginView.routeName);

  static Future<void> pushLoginViewFromLanding(BuildContext context) async =>
      pushNamed(context, LoginView.routeName);

  static Future<void> pushHomeView(BuildContext context) async =>
      pushNamedAndRemoveAll(context, HomeView.routeName);

  static Future<void> pushTrainView(BuildContext context) async =>
      pushNamedAndRemoveAll(context, TrainView.routeName);

  static Future<void> pushLandingView(BuildContext context) async =>
      pushNamedAndRemoveAll(context, LandingView.routeName);

  static Future<void> pushDevelopersView(BuildContext context) async =>
      pushNamed(context, DevelopersView.routeName);

  static Future<void> pushForgetPasswordView(BuildContext context) async =>
      pushNamed(context, ForgetPaswordView.routeName);

  static Future<void> pushEmailVerficationView(
    BuildContext context, {
    required LoginParams param,
  }) async =>
      pushNamed(context, EmailVerficationView.routeName, arguments: param);
}
