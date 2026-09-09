import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/features/onboarding/onboarding_screen.dart'
    show
        kOnboardingWelcomeBackgroundAsset,
        kOnboardingWelcomeBackgroundLightAsset;
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/notifications/notification_service.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/onboarding_typography.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.watch(routineTemplatesProvider);

    ref.listen<AsyncValue<List<RoutineItem>>>(routineTemplatesProvider, (
      prev,
      next,
    ) {
      next.whenData((items) {
        final loc = AppLocalizations.of(context);
        if (loc == null) return;
        NotificationService.instance.syncRoutineReminders(
          items: items,
          notificationTitle: loc.appTitle,
          bodyForItem: (title) => loc.notifRoutineBody(title),
        );
      });
    });

    ref.listen(appLocalePreferenceProvider, (prev, next) {
      if (prev == next) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final loc = AppLocalizations.of(context);
        if (loc == null) return;
        final items = ref.read(routineTemplatesProvider).valueOrNull;
        if (items == null) return;
        NotificationService.instance.syncRoutineReminders(
          items: items,
          notificationTitle: loc.appTitle,
          bodyForItem: (title) => loc.notifRoutineBody(title),
        );
      });
    });

    final brightness = Theme.of(context).brightness;
    final navChrome = OnboardingTypography.shellChromeSurface(brightness);
    final navIndicator = OnboardingTypography.shellChromeNavIndicator(
      brightness,
    );
    final navIcon = OnboardingTypography.shellChromeNavIcon(brightness);
    final navLabel = brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF2D2548);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              brightness == Brightness.dark
                  ? kOnboardingWelcomeBackgroundAsset
                  : kOnboardingWelcomeBackgroundLightAsset,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF0F0A14)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: brightness == Brightness.dark
                      ? [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.72),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.06),
                          Colors.white.withValues(alpha: 0.28),
                        ],
                ),
              ),
            ),
          ),
          widget.navigationShell,
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: Material(
            color: navChrome,
            elevation: brightness == Brightness.light ? 10 : 0,
            shadowColor: brightness == Brightness.light
                ? const Color(0xFF453A7A).withValues(alpha: 0.18)
                : Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: OnboardingTypography.shellChromeBorderColor(brightness),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarTheme.of(context).copyWith(
                  backgroundColor: navChrome,
                  indicatorColor: navIndicator,
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      size: 20,
                      color: selected
                          ? navIcon
                          : navIcon.withValues(alpha: 0.62),
                    );
                  }),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return TextStyle(
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? navLabel
                          : navLabel.withValues(alpha: 0.68),
                    );
                  }),
                ),
              ),
              child: NavigationBar(
                height: 60,
                backgroundColor: navChrome,
                indicatorColor: navIndicator,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: widget.navigationShell.goBranch,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.wb_sunny_outlined),
                    selectedIcon: const Icon(Icons.wb_sunny),
                    label: l10n.navToday,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.calendar_view_week_outlined),
                    selectedIcon: const Icon(Icons.calendar_view_week),
                    label: l10n.navWeek,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.repeat_outlined),
                    selectedIcon: const Icon(Icons.repeat),
                    label: l10n.navRoutine,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.storefront_outlined),
                    selectedIcon: const Icon(Icons.storefront),
                    label: l10n.navShop,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: l10n.navProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
