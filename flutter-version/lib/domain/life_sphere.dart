/// IDs match MASTER_PLAN §2 (`work`, `body`, …).
enum LifeSphere {
  work,
  body,
  social,
  rest,
  home,
  growth,
}

extension LifeSphereStorage on LifeSphere {
  String get id => name;

  static LifeSphere? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in LifeSphere.values) {
      if (s.id == raw) return s;
    }
    return null;
  }

  static LifeSphere parseOrWork(String raw) {
    return tryParse(raw) ?? LifeSphere.work;
  }
}
