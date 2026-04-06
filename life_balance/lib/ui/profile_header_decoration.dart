import 'package:flutter/material.dart';

Color profileHeaderAvatarIconColor(BuildContext context, String? itemId) {
  if (itemId == 'calm_mist_bg' || itemId == 'dawn_gradient_bg') {
    return Colors.white.withValues(alpha: 0.92);
  }
  return Theme.of(context).colorScheme.primary;
}

Color profileHeaderDefaultNameColor(BuildContext context, String? bgId) {
  if (bgId == 'calm_mist_bg' || bgId == 'dawn_gradient_bg') {
    return Colors.white.withValues(alpha: 0.94);
  }
  return Theme.of(context).colorScheme.onSurface;
}

/// Visual for shop profile background ids; [itemId] null or unknown → theme default.
BoxDecoration profileHeaderDecoration(BuildContext context, String? itemId) {
  final scheme = Theme.of(context).colorScheme;
  switch (itemId) {
    case 'calm_mist_bg':
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A3A42),
            Color(0xFF283050),
            Color(0xFF1E2845),
          ],
        ),
      );
    case 'dawn_gradient_bg':
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5C3828),
            Color(0xFF7A4838),
            Color(0xFF2A2238),
          ],
        ),
      );
    default:
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.45),
            scheme.surface,
          ],
        ),
      );
  }
}
