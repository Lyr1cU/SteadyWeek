import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers/onboarding_provider.dart';
import 'package:life_balance/ui/sphere_ui.dart';

/// First onboarding slides use this background (see `assets/branding/`).
const String kOnboardingWelcomeBackgroundAsset = 'assets/branding/background 1.jpg';

// Typography — пропорції як раніше (відносно 36:44:23:21), трохи крупніше.
const double _kFontTopWelcome = 43;
const double _kFontMainTitle = 53;
const double _kFontBody = 28;
const double _kFontButton = 25;
/// Заголовки на скрольних кроках (було 28 при main 44 → ~34 при 53).
const double _kFontScrollSectionTitle = 34;
const double _kOnboardingSparkleIconSize = 26;
const double _kHorizontalPad = 24;
const double _kProgressBarHeight = 5;
/// Єдиний розрив між уже пройденою частиною бару і поточним етапом.
const double _kProgressStageGap = 5;
/// Extra space below SafeArea so skip / bar / welcome sit lower on screen.
const double _kHeaderBlockTopPadding = 52;
/// Shift copy upward in lower-third slides (layout box unchanged for overlap with button row).
const double _kLowerThirdTextLift = 22;
/// Відступ навбару від низу зони PageView — піднято, щоб ряд кнопок був ближче до тексту 1-го слайду.
const double _kOnboardingNavBottomFraction = 0.34;
const double _kOnboardingNavBottomMin = 118;
const double _kOnboardingNavBottomMax = 200;
/// Додатковий низ скролу = навбар + ✨ + запас (разом із navBottom у LayoutBuilder).
const double _kOnboardingScrollPadBeyondNav = 92;

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  int _page = 0;
  static const _totalPages = 5;

  /// Design mock accent (~lavender).
  static const _accentLavender = Color(0xFFB8A9F9);
  static const _onButtonLabel = Color(0xFF1E1B4B);
  static const _segmentInactive = Color(0x33FFFFFF);
  static const _backOutline = Color(0xFFE8E4FF);

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await ref.read(userDisplayNameProvider.notifier).setName(name);
    }
    await ref.read(onboardingCompleteProvider.notifier).complete();
    if (mounted) context.go('/today');
  }

  void _next() {
    if (_page >= _totalPages - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _previous() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  static const _kNavButtonPadding =
      EdgeInsets.symmetric(horizontal: 40, vertical: 26);

  Widget _buildLavenderNextButton({required String label}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _accentLavender.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _accentLavender,
          foregroundColor: _onButtonLabel,
          padding: _kNavButtonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: _next,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: _kFontButton,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedSecondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white.withValues(alpha: 0.95),
          padding: _kNavButtonPadding,
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          side: BorderSide(
            color: _backOutline.withValues(alpha: 0.85),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: _kFontButton,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final topWelcomeStyle = const TextStyle(
      fontSize: _kFontTopWelcome,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.2,
    );

    final mainTitleStyle = const TextStyle(
      fontSize: _kFontMainTitle,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.18,
    );

    final bodyStyle = TextStyle(
      fontSize: _kFontBody,
      fontWeight: FontWeight.w400,
      color: Colors.white.withValues(alpha: 0.92),
      height: 1.68,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              kOnboardingWelcomeBackgroundAsset,
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
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _kHorizontalPad,
                    _kHeaderBlockTopPadding,
                    _kHorizontalPad,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_page < _totalPages - 1)
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildOutlinedSecondaryButton(
                            label: l10n.onboardingSkip,
                            onPressed: _finish,
                          ),
                        ),
                      if (_page < _totalPages - 1)
                        const SizedBox(height: 12)
                      else
                        const SizedBox(height: 28),
                      _StageProgressBar(
                        pageIndex: _page,
                        totalPages: _totalPages,
                        activeColor: _accentLavender,
                        trackColor: _segmentInactive,
                        height: _kProgressBarHeight,
                        stageGap: _kProgressStageGap,
                      ),
                      if (_page == 0) ...[
                        const SizedBox(height: 20),
                        Text(
                          l10n.onboardingAppBarTitle,
                          style: topWelcomeStyle,
                        ),
                      ] else
                        const SizedBox(height: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, viewportConstraints) {
                      final navFromBottom =
                          (viewportConstraints.maxHeight *
                                  _kOnboardingNavBottomFraction)
                              .clamp(
                                _kOnboardingNavBottomMin,
                                _kOnboardingNavBottomMax,
                              )
                              .toDouble();
                      final scrollBottomPad =
                          navFromBottom + _kOnboardingScrollPadBeyondNav;

                      Widget onboardingNavBar() {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            _kHorizontalPad,
                            0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_page > 0)
                                    _buildOutlinedSecondaryButton(
                                      label: l10n.onboardingBack,
                                      onPressed: _previous,
                                    ),
                                  const Spacer(),
                                  _buildLavenderNextButton(
                                    label: _page >= _totalPages - 1
                                        ? l10n.onboardingGetStarted
                                        : l10n.onboardingNext,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Opacity(
                                  opacity: _page < 2 ? 1 : 0,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: _kOnboardingSparkleIconSize,
                                    color: Colors.white
                                        .withValues(alpha: 0.95),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned.fill(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (i) =>
                                  setState(() => _page = i),
                              children: [
                                _OnboardingLowerThirdSlide(
                                  horizontalPad: _kHorizontalPad,
                                  topHeadline: null,
                                  topHeadlineStyle: topWelcomeStyle,
                                  mainTitle: l10n.onboardingWelcomeTitle,
                                  mainTitleStyle: mainTitleStyle,
                                  body: l10n.onboardingWelcomeBody,
                                  body2: l10n.onboardingWelcomeBody2,
                                  bodyStyle: bodyStyle,
                                  topSpacerFlex: 3,
                                  bottomSpacerFlex: 5,
                                ),
                                _OnboardingLowerThirdSlide(
                                  horizontalPad: _kHorizontalPad,
                                  topHeadline: null,
                                  topHeadlineStyle: topWelcomeStyle,
                                  mainTitle:
                                      l10n.onboardingPhilosophyTitle,
                                  mainTitleStyle: mainTitleStyle,
                                  body: l10n.onboardingPhilosophyBody,
                                  bodyStyle: bodyStyle,
                                  topSpacerFlex: 3,
                                  bottomSpacerFlex: 5,
                                ),
                                _OnboardingScrollPage(
                                  horizontalPad: _kHorizontalPad,
                                  bottomPadding: scrollBottomPad,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.onboardingSpheresTitle,
                                        style: mainTitleStyle.copyWith(
                                          fontSize:
                                              _kFontScrollSectionTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.onboardingSpheresBody,
                                        style: bodyStyle,
                                      ),
                                      const SizedBox(height: 16),
                                      _OnboardingGlassSphereGrid(
                                        l10n: l10n,
                                        labelStyle: bodyStyle,
                                        accentLavender: _accentLavender,
                                      ),
                                    ],
                                  ),
                                ),
                                _OnboardingScrollPage(
                                  horizontalPad: _kHorizontalPad,
                                  bottomPadding: scrollBottomPad,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.onboardingPlanTitle,
                                        style: mainTitleStyle.copyWith(
                                          fontSize:
                                              _kFontScrollSectionTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.onboardingPlanBody,
                                        style: bodyStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                _OnboardingScrollPage(
                                  horizontalPad: _kHorizontalPad,
                                  bottomPadding: scrollBottomPad,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.onboardingFinishTitle,
                                        style: mainTitleStyle.copyWith(
                                          fontSize:
                                              _kFontScrollSectionTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: _nameController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: _kFontBody,
                                        ),
                                        decoration: InputDecoration(
                                          labelText:
                                              l10n.onboardingNameHint,
                                          labelStyle: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                            fontSize: _kFontBody - 1,
                                          ),
                                          enabledBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.35),
                                            ),
                                          ),
                                          focusedBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                const BorderSide(
                                              color: _accentLavender,
                                            ),
                                          ),
                                        ),
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        l10n.onboardingTourTitle,
                                        style: TextStyle(
                                          fontSize: _kFontBody,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '• ${l10n.onboardingTourToday}',
                                        style: bodyStyle,
                                      ),
                                      Text(
                                        '• ${l10n.onboardingTourWeek}',
                                        style: bodyStyle,
                                      ),
                                      Text(
                                        '• ${l10n.onboardingTourCloseDay}',
                                        style: bodyStyle,
                                      ),
                                      Text(
                                        '• ${l10n.onboardingTourProfile}',
                                        style: bodyStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: navFromBottom,
                            child: onboardingNavBar(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Суцільна активна частина до кінця попередніх етапів → один розрив → поточний етап → суцільний трек.
class _StageProgressBar extends StatelessWidget {
  const _StageProgressBar({
    required this.pageIndex,
    required this.totalPages,
    required this.activeColor,
    required this.trackColor,
    this.height = 5,
    this.stageGap = 5,
  });

  final int pageIndex;
  final int totalPages;
  final Color activeColor;
  final Color trackColor;
  final double height;
  final double stageGap;

  @override
  Widget build(BuildContext context) {
    final r = height / 2;
    final future = totalPages - pageIndex - 1;
    final hasCompleted = pageIndex > 0;

    BorderRadius completedBarRadius() => BorderRadius.only(
          topLeft: Radius.circular(r),
          bottomLeft: Radius.circular(r),
        );

    BorderRadius futureBarRadius() => BorderRadius.only(
          topRight: Radius.circular(r),
          bottomRight: Radius.circular(r),
        );

    BorderRadius currentBarRadius() {
      if (!hasCompleted && future > 0) {
        return BorderRadius.only(
          topLeft: Radius.circular(r),
          bottomLeft: Radius.circular(r),
        );
      }
      if (hasCompleted && future > 0) {
        return BorderRadius.zero;
      }
      if (hasCompleted && future <= 0) {
        return BorderRadius.only(
          topRight: Radius.circular(r),
          bottomRight: Radius.circular(r),
        );
      }
      return BorderRadius.circular(r);
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          if (hasCompleted) ...[
            Expanded(
              flex: pageIndex,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                height: height,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: completedBarRadius(),
                ),
              ),
            ),
            SizedBox(width: stageGap),
          ],
          Expanded(
            flex: 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: height,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: currentBarRadius(),
              ),
            ),
          ),
          if (future > 0) ...[
            Expanded(
              flex: future,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                height: height,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: futureBarRadius(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mock layout: headline under progress, modest gap, then main block + sparkle — clustered toward vertical center (not pinned to bottom edge).
class _OnboardingLowerThirdSlide extends StatelessWidget {
  const _OnboardingLowerThirdSlide({
    required this.horizontalPad,
    required this.topHeadlineStyle,
    required this.mainTitle,
    required this.mainTitleStyle,
    required this.body,
    required this.bodyStyle,
    this.topHeadline,
    this.body2,
    this.topSpacerFlex = 5,
    this.bottomSpacerFlex = 3,
  });

  final double horizontalPad;
  final String? topHeadline;
  final TextStyle topHeadlineStyle;
  final String mainTitle;
  final TextStyle mainTitleStyle;
  final String body;
  final String? body2;
  final TextStyle bodyStyle;
  final int topSpacerFlex;
  final int bottomSpacerFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final hasHeadline =
            topHeadline != null && topHeadline!.isNotEmpty;
        final gapHeadlineToMain = hasHeadline
            ? 20.0 + h * 0.055
            : 16.0 + h * 0.035;

        return Padding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(flex: topSpacerFlex),
              if (hasHeadline) Text(topHeadline!, style: topHeadlineStyle),
              SizedBox(height: gapHeadlineToMain),
              Transform.translate(
                offset: const Offset(0, -_kLowerThirdTextLift),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mainTitle, style: mainTitleStyle),
                    const SizedBox(height: 14),
                    Text(body, style: bodyStyle),
                    if (body2 != null && body2!.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Text(body2!, style: bodyStyle),
                    ],
                  ],
                ),
              ),
              Spacer(flex: bottomSpacerFlex),
            ],
          ),
        );
      },
    );
  }
}

/// Скло + рамка; іконка в градієнтному квадраті (як на макеті онбордингу).
class _OnboardingGlassSphereGrid extends StatelessWidget {
  const _OnboardingGlassSphereGrid({
    required this.l10n,
    required this.labelStyle,
    required this.accentLavender,
  });

  final AppLocalizations l10n;
  final TextStyle labelStyle;
  final Color accentLavender;

  @override
  Widget build(BuildContext context) {
    const gap = 16.0;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final s in LifeSphere.values)
          _GlassSphereTile(
            sphere: s,
            l10n: l10n,
            labelStyle: labelStyle,
            accentLavender: accentLavender,
          ),
      ],
    );
  }
}

class _GlassSphereTile extends StatelessWidget {
  const _GlassSphereTile({
    required this.sphere,
    required this.l10n,
    required this.labelStyle,
    required this.accentLavender,
  });

  final LifeSphere sphere;
  final AppLocalizations l10n;
  final TextStyle labelStyle;
  final Color accentLavender;

  static const _iconBox = 50.0;
  static const _radius = 18.0;
  static const _blurSigma = 18.0;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(accentLavender, Colors.white, 0.55)!
        .withValues(alpha: 0.42);

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
        child: IntrinsicWidth(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: borderColor, width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.05),
                  accentLavender.withValues(alpha: 0.06),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _OnboardingSphereIconGem(
                    icon: sphereOnboardingIcon(sphere),
                    accentLavender: accentLavender,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sphereLabel(l10n, sphere),
                    style: labelStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
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

class _OnboardingSphereIconGem extends StatelessWidget {
  const _OnboardingSphereIconGem({
    required this.icon,
    required this.accentLavender,
  });

  final IconData icon;
  final Color accentLavender;

  @override
  Widget build(BuildContext context) {
    const r = 14.0;
    return Container(
      width: _GlassSphereTile._iconBox,
      height: _GlassSphereTile._iconBox,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(accentLavender, Colors.white, 0.35)!,
            accentLavender,
            Color.lerp(accentLavender, const Color(0xFF4C3D9E), 0.45)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: accentLavender.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.35),
            blurRadius: 3,
            spreadRadius: -2,
            offset: const Offset(-1, -2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 26,
        color: Colors.white.withValues(alpha: 0.96),
      ),
    );
  }
}

class _OnboardingScrollPage extends StatelessWidget {
  const _OnboardingScrollPage({
    required this.child,
    required this.horizontalPad,
    this.bottomPadding = 24,
  });

  final Widget child;
  final double horizontalPad;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        16,
        horizontalPad,
        bottomPadding,
      ),
      child: child,
    );
  }
}
