import 'dart:math';

import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/l10n/app_localizations.dart';

final _rand = Random();

const laconicVoicePackId = 'voice_pack_laconic';

/// Short supportive lines — MASTER_PLAN §10 (no LLM).
String assistantAfterCloseDay(
  AppLocalizations l,
  DayTier tier,
  int newStreak, {
  String? voicePackId,
}) {
  final laconic = voicePackId == laconicVoicePackId;
  return switch (tier) {
    DayTier.green => laconic
        ? _pick([
            () => l.assistantLaconicCloseGreenA(newStreak),
            () => l.assistantLaconicCloseGreenB,
          ])
        : _pick([
            () => l.assistantCloseGreenA(newStreak),
            () => l.assistantCloseGreenB,
          ]),
    DayTier.yellow => laconic
        ? _pick([
            () => l.assistantLaconicCloseYellowA,
            () => l.assistantLaconicCloseYellowB,
          ])
        : _pick([
            () => l.assistantCloseYellowA,
            () => l.assistantCloseYellowB,
          ]),
    DayTier.red => laconic
        ? _pick([
            () => l.assistantLaconicCloseRedA,
            () => l.assistantLaconicCloseRedB,
          ])
        : _pick([
            () => l.assistantCloseRedA,
            () => l.assistantCloseRedB,
          ]),
  };
}

String assistantAfterShopPurchase(
  AppLocalizations l, {
  String? voicePackId,
}) {
  final laconic = voicePackId == laconicVoicePackId;
  return laconic
      ? _pick([
          () => l.assistantLaconicShopA,
          () => l.assistantLaconicShopB,
        ])
      : _pick([
          () => l.assistantShopA,
          () => l.assistantShopB,
        ]);
}

String assistantAfterWeeklyGoalDone(
  AppLocalizations l, {
  String? voicePackId,
}) {
  final laconic = voicePackId == laconicVoicePackId;
  return laconic
      ? _pick([
          () => l.assistantLaconicGoalA,
          () => l.assistantLaconicGoalB,
        ])
      : _pick([
          () => l.assistantGoalDoneA,
          () => l.assistantGoalDoneB,
        ]);
}

String _pick(List<String Function()> options) {
  return options[_rand.nextInt(options.length)]();
}
