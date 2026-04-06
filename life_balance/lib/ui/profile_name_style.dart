import 'package:flutter/material.dart';

/// Display name with optional shop cosmetic.
Widget profileStyledDisplayName({
  required String name,
  required String? nameStyleId,
  TextStyle? baseStyle,
}) {
  final themeBase = baseStyle ??
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  switch (nameStyleId) {
    case 'name_gradient_gold':
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFFFF9C4),
            Color(0xFFFFCA28),
            Color(0xFFFF8F00),
            Color(0xFFFF6F00),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: themeBase.copyWith(color: Colors.white),
        ),
      );
    case 'name_soft_violet':
      return Text(
        name,
        textAlign: TextAlign.center,
        style: themeBase.copyWith(
          color: const Color(0xFF7E57C2),
          shadows: [
            Shadow(
              color: const Color(0xFF5E35B1).withValues(alpha: 0.35),
              blurRadius: 8,
            ),
          ],
        ),
      );
    default:
      return Text(
        name,
        textAlign: TextAlign.center,
        style: themeBase,
      );
  }
}
