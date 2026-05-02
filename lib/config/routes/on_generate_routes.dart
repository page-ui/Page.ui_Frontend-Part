import 'package:page_ui/features/auth/data/model/user_tokens_model.dart';
import 'package:page_ui/features/auth/domain/params/login_params.dart';
import 'package:page_ui/features/auth/presentation/views/email_verfication_view.dart';
import 'package:page_ui/features/auth/presentation/views/forget_pasword_view.dart';
import 'package:page_ui/features/auth/presentation/views/login_view.dart';
import 'package:page_ui/features/auth/presentation/views/register_view.dart';
import 'package:page_ui/features/auth/presentation/views/train_view.dart';
import 'package:page_ui/features/chat/presentation/views/home_view.dart';
import 'package:page_ui/features/intro_screens/presentation/views/developers_view.dart';
import 'package:page_ui/features/intro_screens/presentation/views/landing_view.dart';
import 'package:page_ui/features/intro_screens/presentation/views/splash_view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

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

  static CustomTransitionPage<T> _transitionPage<T>({
    required LocalKey key,
    required Widget child,
    int durationMs = 500,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      transitionDuration: Duration(milliseconds: durationMs),
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(1.8, 0),
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
    );
  }

  static const _protectedRoutes = {homePath, trainPath};
  static const _authRoutes = {
    loginPath,
    registerPath,
    forgetPasswordPath,
    emailVerificationPath,
    splashPath,
    landingPath,
  };

  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final tokens = await returnTokensFromSecureDB();
    final isLoggedIn = !tokens.isEmpty();
    final location = state.matchedLocation;

    if (isLoggedIn && _authRoutes.contains(location)) return homePath;
    if (!isLoggedIn && _protectedRoutes.contains(location)) return loginPath;
    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: landingPath,
    redirect: _redirect,
    routes: <RouteBase>[
      GoRoute(
        path: landingPath,
        name: LandingView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const LandingView()),
      ),
      GoRoute(
        path: splashPath,
        name: SplashView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const SplashView()),
      ),
      GoRoute(
        path: developersPath,
        name: DevelopersView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const DevelopersView()),
      ),
      GoRoute(
        path: loginPath,
        name: LoginView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const LoginView()),
      ),
      GoRoute(
        path: registerPath,
        name: RegisterView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const RegisterView()),
      ),
      GoRoute(
        path: forgetPasswordPath,
        name: ForgetPaswordView.routeName,
        pageBuilder: (_, state) => _transitionPage(
          key: state.pageKey,
          child: const ForgetPaswordView(),
        ),
      ),
      GoRoute(
        path: emailVerificationPath,
        name: EmailVerficationView.routeName,
        pageBuilder: (_, state) => _transitionPage(
          key: state.pageKey,
          child: EmailVerficationView(param: state.extra as LoginParams),
        ),
      ),
      GoRoute(
        path: homePath,
        name: HomeView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const HomeView()),
      ),
      GoRoute(
        path: trainPath,
        name: TrainView.routeName,
        pageBuilder: (_, state) =>
            _transitionPage(key: state.pageKey, child: const TrainView()),
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

  static Future<T?> pushPageReplacementNamed<T extends Object?>(
    BuildContext context,
    String newRouteName, {
    Object? arguments,
  }) async {
    context.pushReplacementNamed(newRouteName, extra: arguments);
    return null;
  }

  static Future<void> pushSplashView(BuildContext context) async =>
      pushNamed(context, SplashView.routeName);

  static Future<void> pushRegisterView(BuildContext context) async =>
      pushNamed(context, RegisterView.routeName);

  static Future<void> pushLoginView(BuildContext context) async =>
      pushPageReplacementNamed(context, LoginView.routeName);

  static Future<void> pushLoginViewWithReturn(BuildContext context) async =>
      pushNamed(context, LoginView.routeName);

  static Future<void> pushHomeView(BuildContext context) async =>
      pushPageReplacementNamed(context, HomeView.routeName);

  static Future<void> pushTrainView(BuildContext context) async =>
      pushPageReplacementNamed(context, TrainView.routeName);

  static Future<void> pushLandingView(BuildContext context) async =>
      pushPageReplacementNamed(context, LandingView.routeName);

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
