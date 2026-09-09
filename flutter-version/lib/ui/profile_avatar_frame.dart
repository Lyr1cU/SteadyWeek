import 'package:flutter/material.dart';

/// Optional shop frame around a circular [child] (e.g. [CircleAvatar]).
Widget profileAvatarFrame({required String? frameId, required Widget child}) {
  switch (frameId) {
    case 'lavender_soft_frame':
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFB39DDB), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E57C2).withValues(alpha: 0.42),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      );
    case 'ember_streak_frame':
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFF6F00), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3D00).withValues(alpha: 0.48),
              blurRadius: 14,
            ),
          ],
        ),
        child: child,
      );
    default:
      return child;
  }
}
