import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/notifications/notification_service.dart';
import 'package:life_balance/providers.dart';

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

    ref.listen<AsyncValue<List<RoutineItem>>>(
      routineTemplatesProvider,
      (prev, next) {
        next.whenData((items) {
          final loc = AppLocalizations.of(context);
          if (loc == null) return;
          NotificationService.instance.syncRoutineReminders(
            items: items,
            notificationTitle: loc.appTitle,
            bodyForItem: (title) => loc.notifRoutineBody(title),
          );
        });
      },
    );

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

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
