import 'package:flutter/material.dart';
import 'package:life_balance/features/onboarding/onboarding_screen.dart'
    show
        kOnboardingWelcomeBackgroundAsset,
        kOnboardingWelcomeBackgroundLightAsset;
import 'package:life_balance/ui/onboarding_typography.dart';

/// Frosted glass (dark) or solid white card with shadow (light) — same as Today tiles.
class ChromeCard extends StatelessWidget {
  const ChromeCard({
    super.key,
    required this.child,
    this.borderRadius = 18,
    this.lightElevation = 4,

    /// Dark theme: nearly opaque panel for dialogs so content behind does not show through.
    this.useModalSurface = false,
  });

  final Widget child;
  final double borderRadius;
  final double lightElevation;
  final bool useModalSurface;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = OnboardingTypography.accentLavender;
    final borderColor = isDark
        ? Color.lerp(accent, Colors.white, 0.55)!.withValues(alpha: 0.42)
        : OnboardingTypography.shellChromeBorderColor(Brightness.light);

    if (!isDark) {
      return Material(
        color: Colors.white,
        elevation: lightElevation,
        shadowColor: const Color(0xFF453A7A).withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    if (useModalSurface) {
      return Material(
        color: const Color(0xEE1C1C2A),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    // No BackdropFilter: full-screen blur behind every list row kills scroll FPS on
    // many phones. Gradient + border keeps a similar "glass" read without GPU blur.
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.08),
              accent.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Full-screen mesh background + scrim (Close day, Weekly report, Assistant, Auth).
class ChromePageBackground extends StatelessWidget {
  const ChromePageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Stack(
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
      ],
    );
  }
}

/// [MenuAnchor] styling: dark frosted menu vs light white menu.
MenuStyle menuStyleFor(BuildContext context, {Color? accent}) {
  final brightness = Theme.of(context).brightness;
  final acc = accent ?? OnboardingTypography.accentLavender;
  final rim = brightness == Brightness.dark
      ? Color.lerp(acc, Colors.white, 0.42)!.withValues(alpha: 0.62)
      : acc.withValues(alpha: 0.25);

  return MenuStyle(
    backgroundColor: WidgetStateProperty.all(
      brightness == Brightness.dark
          ? const Color(0xFF252038).withValues(alpha: 0.97)
          : Colors.white.withValues(alpha: 0.97),
    ),
    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    shadowColor: WidgetStateProperty.all(acc.withValues(alpha: 0.42)),
    elevation: WidgetStateProperty.all(14),
    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 6)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: rim, width: 1.5),
      ),
    ),
  );
}
