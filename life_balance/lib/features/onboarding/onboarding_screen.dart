import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers/onboarding_provider.dart';
import 'package:life_balance/ui/sphere_ui.dart';

/// First onboarding slides use this background (see `assets/branding/`).
const String kOnboardingWelcomeBackgroundAsset = 'assets/branding/background 1.jpg';

// Typography aligned to design mock (logical px).
const double _kFontTopWelcome = 36;
const double _kFontMainTitle = 44;
const double _kFontBody = 23;
const double _kFontButton = 21;
const double _kFontSkip = 14;
const double _kHorizontalPad = 24;
const double _kProgressBarHeight = 5;
/// Єдиний розрив між уже пройденою частиною бару і поточним етапом.
const double _kProgressStageGap = 5;
/// Extra space below SafeArea so skip / bar / welcome sit lower on screen.
const double _kHeaderBlockTopPadding = 52;
/// Shift copy upward in lower-third slides (layout box unchanged for overlap with button row).
const double _kLowerThirdTextLift = 22;
const double _kLowerThirdTextToButtonGap = 10;
/// Pulls the button row up so vertical placement stays close to the old side‑by‑side layout.
const double _kLowerThirdButtonRowLift = 14;

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

  Widget _buildOutlinedBackButton({required String label}) {
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
        onPressed: _previous,
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

    final skipStyle = TextStyle(
      fontSize: _kFontSkip,
      fontWeight: FontWeight.w500,
      color: Colors.white.withValues(alpha: 0.65),
    );

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
                          child: TextButton(
                            onPressed: _finish,
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Colors.white.withValues(alpha: 0.65),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(l10n.onboardingSkip, style: skipStyle),
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
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _page = i),
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
                        nextButton: _buildLavenderNextButton(label: l10n.onboardingNext),
                      ),
                      _OnboardingLowerThirdSlide(
                        horizontalPad: _kHorizontalPad,
                        topHeadline: null,
                        topHeadlineStyle: topWelcomeStyle,
                        backButton:
                            _buildOutlinedBackButton(label: l10n.onboardingBack),
                        mainTitle: l10n.onboardingPhilosophyTitle,
                        mainTitleStyle: mainTitleStyle,
                        body: l10n.onboardingPhilosophyBody,
                        bodyStyle: bodyStyle,
                        nextButton: _buildLavenderNextButton(label: l10n.onboardingNext),
                      ),
                      _OnboardingScrollPage(
                        horizontalPad: _kHorizontalPad,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.onboardingSpheresTitle,
                              style: mainTitleStyle.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.onboardingSpheresBody, style: bodyStyle),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: LifeSphere.values
                                  .map(
                                    (s) => Chip(
                                      avatar: Icon(sphereIcon(s), size: 18),
                                      label: Text(sphereLabel(l10n, s)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      _OnboardingScrollPage(
                        horizontalPad: _kHorizontalPad,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.onboardingPlanTitle,
                              style: mainTitleStyle.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.onboardingPlanBody, style: bodyStyle),
                          ],
                        ),
                      ),
                      _OnboardingScrollPage(
                        horizontalPad: _kHorizontalPad,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.onboardingFinishTitle,
                              style: mainTitleStyle.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: _kFontBody,
                              ),
                              decoration: InputDecoration(
                                labelText: l10n.onboardingNameHint,
                                labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: _kFontBody - 1,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _accentLavender,
                                  ),
                                ),
                              ),
                              textCapitalization: TextCapitalization.words,
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
                            Text('• ${l10n.onboardingTourToday}', style: bodyStyle),
                            Text('• ${l10n.onboardingTourWeek}', style: bodyStyle),
                            Text('• ${l10n.onboardingTourCloseDay}', style: bodyStyle),
                            Text('• ${l10n.onboardingTourProfile}', style: bodyStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_page >= 2)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, _kHorizontalPad, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildOutlinedBackButton(label: l10n.onboardingBack),
                        const Spacer(),
                        _buildLavenderNextButton(
                          label: _page >= _totalPages - 1
                              ? l10n.onboardingGetStarted
                              : l10n.onboardingNext,
                        ),
                      ],
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
    required this.nextButton,
    this.topHeadline,
    this.body2,
    this.backButton,
  });

  final double horizontalPad;
  final String? topHeadline;
  final TextStyle topHeadlineStyle;
  final String mainTitle;
  final TextStyle mainTitleStyle;
  final String body;
  final String? body2;
  final TextStyle bodyStyle;
  final Widget nextButton;
  final Widget? backButton;

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
              // Eat space above so the copy block sits lower (closer to visual center / mock).
              const Spacer(flex: 5),
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
              Transform.translate(
                offset: const Offset(0, -_kLowerThirdButtonRowLift),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: _kLowerThirdTextToButtonGap),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ?backButton,
                        const Spacer(),
                        nextButton,
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.auto_awesome,
                  size: 22,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        );
      },
    );
  }
}

class _OnboardingScrollPage extends StatelessWidget {
  const _OnboardingScrollPage({
    required this.child,
    required this.horizontalPad,
  });

  final Widget child;
  final double horizontalPad;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPad, 16, horizontalPad, 24),
      child: child,
    );
  }
}
