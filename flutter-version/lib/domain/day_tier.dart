/// Stored in [DailyReports.dayTier] (MASTER_PLAN §6).
enum DayTier {
  green(0),
  yellow(1),
  red(2);

  const DayTier(this.storageValue);
  final int storageValue;

  static DayTier fromStorage(int v) {
    return DayTier.values.firstWhere(
      (e) => e.storageValue == v,
      orElse: () => DayTier.red,
    );
  }
}
