import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/features/assistant/assistant_screen.dart';
import 'package:life_balance/features/auth/auth_screen.dart';
import 'package:life_balance/features/close_day/close_day_screen.dart';
import 'package:life_balance/features/onboarding/onboarding_screen.dart';
import 'package:life_balance/features/profile/profile_screen.dart';
import 'package:life_balance/features/routine/routine_screen.dart';
import 'package:life_balance/features/shop/shop_screen.dart';
import 'package:life_balance/features/shell/main_shell.dart';
import 'package:life_balance/features/today/today_screen.dart';
import 'package:life_balance/features/week/week_screen.dart';
import 'package:life_balance/features/week/weekly_report_screen.dart';
import 'package:life_balance/providers/onboarding_provider.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(goRouterRefreshProvider);
  return GoRouter(
    navigatorKey: _rootKey,
    refreshListenable: refresh,
    initialLocation: '/today',
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final done = container.read(onboardingCompleteProvider);
      final path = state.matchedLocation;
      if (!done && path != '/onboarding' && path != '/auth') {
        return '/onboarding';
      }
      if (done && path == '/onboarding') {
        return '/today';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/assistant',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AssistantScreen(),
      ),
      GoRoute(
        path: '/close-day',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final d = state.uri.queryParameters['d'];
          final key = (d != null && d.isNotEmpty)
              ? d
              : dateKey(DateTime.now());
          return CloseDayScreen(dayKey: key);
        },
      ),
      GoRoute(
        path: '/weekly-report',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final w = state.uri.queryParameters['w'];
          final key = (w != null && w.isNotEmpty)
              ? w
              : weekKeyFromDate(DateTime.now());
          return WeeklyReportScreen(weekKey: key);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TodayScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/week',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: WeekScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/routine',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RoutineScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ShopScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
