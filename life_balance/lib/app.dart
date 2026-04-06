import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:life_balance/core/app_theme_preference.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers/locale_preference_provider.dart';
import 'package:life_balance/providers/theme_preference_provider.dart';
import 'package:life_balance/ui/app_theme.dart';
import 'router/app_router.dart';

class LifeBalanceApp extends ConsumerWidget {
  const LifeBalanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePref = ref.watch(themePreferenceProvider);
    final localePref = ref.watch(appLocalePreferenceProvider);
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themePref.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: resolveAppLocale(localePref),
      localeResolutionCallback: (deviceLocale, supported) {
        if (deviceLocale == null) return const Locale('en');
        for (final locale in supported) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }
        return const Locale('en');
      },
    );
  }
}
