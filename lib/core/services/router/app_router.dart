import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/features/auth/views/pages/forgot_password_screen.dart';
import '../../../ui/features/auth/views/pages/login_screen.dart';
import '../../../ui/features/auth/views/pages/register_screen.dart';
import '../../../ui/features/home/views/pages/home_screen.dart';
import '../../../ui/features/profile/views/pages/profile_screen.dart';
import '../../../ui/features/main_wrapper/views/pages/main_wrapper_screen.dart';
import '../../../ui/features/settings/views/languages_settings_screen.dart';
import '../../../ui/features/splash/views/pages/splash_screen.dart';
import '../../../ui/features/onboarding/views/pages/onboarding_screen.dart';

class AppRouter {
  static const String splash = "/splash";
  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String forgotPassword = "/forgot_password";
  static const String home = "/home";
  static const String map = "/map";
  static const String profile = "/profile";
  static const String languages = "/languages";
  static const String locationPicker = "/location_picker";

  static String toName(String path) => path.replaceFirst("/", "");

  /// Root Navigator Key
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Navigator key for root Shell Route
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splash,
    // redirect: (context, state) {
    //   final unprotected = [
    //     splash,
    //     onboarding,
    //     login,
    //     register,
    //     forgotPassword,
    //   ];
    //
    //   if (unprotected.contains(state.matchedLocation)) {
    //     return null;
    //   }
    //
    //   final container = ProviderScope.containerOf(context);
    //   final loggedIn = container.read(userLoggedInStateProvider);
    //   if (loggedIn) return null;
    //   return login;
    // },
    routes: [
      GoRoute(
        path: splash,
        name: toName(splash),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: onboarding,
        name: toName(onboarding),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: login,
        name: toName(login),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: register,
        name: toName(register),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: forgotPassword,
        name: toName(forgotPassword),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: languages,
        name: toName(languages),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: const LanguagesSettingsScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, state, shell) => MainWrapperScreen(
          shell: shell,
          state: state,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: toName(home),
                pageBuilder: (_, state) => _pageBuilder(
                  state: state,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: toName(profile),
                pageBuilder: (_, state) => _pageBuilder(
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  /// Page builder helper function
  static Page<T> _pageBuilder<T>({
    required GoRouterState state,
    required Widget child,
    TransitionType transitionType = TransitionType.none,
    RoundedType roundedType = RoundedType.none,
    Color borderColor = Colors.white,
  }) {
    if (roundedType != RoundedType.none) {
      child = Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: roundedType == RoundedType.all
              ? BorderRadius.circular(12.0)
              : BorderRadius.vertical(
                  top: roundedType == RoundedType.onlyTop
                      ? const Radius.circular(12.0)
                      : Radius.zero,
                  bottom: roundedType == RoundedType.onlyBottom
                      ? const Radius.circular(12.0)
                      : Radius.zero,
                ),
          side: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    if (transitionType == TransitionType.none) {
      return NoTransitionPage<T>(child: child);
    }

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        if (transitionType == TransitionType.scale) {
          return ScaleTransition(scale: animation, child: child);
        }

        if (transitionType == TransitionType.fade) {
          return FadeTransition(opacity: animation, child: child);
        }

        if (transitionType == TransitionType.slide) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.5, 0),
                end: Offset.zero,
              ).chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child,
          );
        }

        return AlignTransition(
          alignment: animation.drive(
            Tween(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).chain(
              CurveTween(curve: Curves.ease),
            ),
          ),
          child: child,
        );
      },
    );
  }
}

/// Transition type for route
enum TransitionType {
  slide,
  scale,
  fade,
  align,
  none,
}

/// Rounded Type for screen
enum RoundedType {
  all,
  onlyTop,
  onlyBottom,
  none,
}
