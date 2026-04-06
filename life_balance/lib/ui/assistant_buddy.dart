import 'package:flutter/material.dart';

/// Round emoji-style buddy with optional shop layers (owned item ids).
class AssistantBuddy extends StatelessWidget {
  const AssistantBuddy({
    super.key,
    required this.ownedLayerIds,
    this.size = 88,
  });

  final Set<String> ownedLayerIds;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final faceSize = size * 0.72;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: faceSize,
            height: faceSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scheme.primaryContainer,
                  scheme.tertiaryContainer,
                ],
              ),
            ),
            child: Icon(
              Icons.sentiment_satisfied_alt_rounded,
              size: size * 0.38,
              color: scheme.onPrimaryContainer,
            ),
          ),
          if (ownedLayerIds.contains('assistant_cap_party'))
            Positioned(
              top: size * 0.02,
              child: Icon(
                Icons.celebration_rounded,
                size: size * 0.28,
                color: scheme.primary,
              ),
            ),
          if (ownedLayerIds.contains('assistant_scarf_cozy'))
            Positioned(
              bottom: size * 0.2,
              child: Icon(
                Icons.checkroom_outlined,
                size: size * 0.26,
                color: scheme.secondary,
              ),
            ),
          if (ownedLayerIds.contains('sticker_balance_set'))
            Positioned(
              right: size * 0.02,
              bottom: size * 0.06,
              child: Icon(
                Icons.auto_awesome,
                size: size * 0.22,
                color: scheme.tertiary,
              ),
            ),
        ],
      ),
    );
  }
}
