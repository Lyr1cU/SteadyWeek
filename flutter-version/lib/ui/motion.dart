import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared motion timings and route page builders.

const Duration kSheetTransitionDuration = Duration(milliseconds: 280);

const Duration kTabSwitchDuration = Duration(milliseconds: 200);

const double kPressedScale = 0.975;

const Curve kPressCurve = Curves.easeOutCubic;

const Curve kReleaseCurve = Curves.easeOutCubic;

const Duration kPressScaleDuration = Duration(milliseconds: 110);

Duration sheetTransitionDuration(BuildContext context) {
  final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return disable ? Duration.zero : kSheetTransitionDuration;
}

Duration tabSwitchDuration(BuildContext context) {
  final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return disable ? Duration.zero : kTabSwitchDuration;
}

Duration pressScaleDuration(BuildContext context) {
  final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return disable ? Duration.zero : kPressScaleDuration;
}

/// Full-screen chrome routes pushed over the shell (slide + fade).
CustomTransitionPage<void> chromeFullscreenPage({
  required BuildContext context,
  required LocalKey pageKey,
  required Widget child,
}) {
  final duration = sheetTransitionDuration(context);
  final curve = Curves.easeOutCubic;

  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (ctx, animation, secondaryAnimation, c) {
      final offsetAnimation = animation.drive(
        Tween(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve)),
      );
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: SlideTransition(position: offsetAnimation, child: c),
      );
    },
  );
}

/// Fade-only transition for shell tab branches.
CustomTransitionPage<void> shellTabPage({
  required BuildContext context,
  required LocalKey pageKey,
  required Widget child,
}) {
  final duration = tabSwitchDuration(context);
  final curve = Curves.easeOutCubic;

  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (ctx, animation, _, c) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: c,
      );
    },
  );
}
