import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
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
      // Phones often use Display size / Font size > default; Flutter scales the
      // whole text tree. Cap so UI matches design and avoids huge chrome.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final capped = mq.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.0,
        );
        // Mobile shells often feel huge vs desktop window; tighten on phones only.
        final mobile = !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS);
        final factor = capped.scale(1.0) * (mobile ? 0.9 : 1.0);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(factor)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
