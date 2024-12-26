import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/features/onboarding/providers/is_already_onboarded_provider.dart';
import '../../../../../utils/extension_functions.dart';
import '../../../../../core/services/router/app_router.dart';
import '../../../auth/provider/user_logged_in_state_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final _minimumDelayed = 1000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Calling function to handle navigation
      _handleNavigate();
    });
  }

  /// Method to handle navigation after certain time
  ///
  void _handleNavigate() {
    final rand = Random().nextInt(1500);
    final delayed = rand + _minimumDelayed;

    final isLoggedIn = ref.read(userLoggedInStateProvider);

    Future.delayed(Duration(milliseconds: delayed), () {
      if (!mounted) return;
      final isAlreadyOnboarded = ref.read(isAlreadyOnboardedProvider);

      context.goNamed(
        isLoggedIn
            ? AppRouter.home.toPathName
            : isAlreadyOnboarded
                ? AppRouter.login.toPathName
                : AppRouter.onboarding.toPathName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Text(
            context.flavorConfiguration.flavor.localizedAppName(
              context,
            ),
            style: context.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
