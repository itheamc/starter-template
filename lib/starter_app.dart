import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/router/app_router.dart';
import 'core/styles/app_theme.dart';
import 'l10n/l10n.dart';

/// Main App Widget
///
class StarterApp extends ConsumerStatefulWidget {
  /// Creates new instance of [StarterApp]
  const StarterApp({super.key});

  @override
  ConsumerState<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends ConsumerState<StarterApp> {
  @override
  void initState() {
    super.initState();

    // Set app orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeStateProvider);

    return MaterialApp.router(
      title: "Starter Template",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      routerConfig: AppRouter.router,
    );
  }
}
