import 'package:life_balance/domain/day_tier.dart';

/// Tunable constants — MASTER_PLAN §7.
int xpForEffort(int effortLevel, {required bool isOptional}) {
  var base = switch (effortLevel) {
    0 => 5,
    1 => 8,
    2 => 12,
    _ => 5,
  };
  if (isOptional) {
    base = (base / 2).floor();
  }
  return base;
}

const int routineXpDailyCap = 200;

int xpTierBonus(DayTier tier) => switch (tier) {
      DayTier.green => 25,
      DayTier.yellow => 10,
      DayTier.red => 0,
    };
