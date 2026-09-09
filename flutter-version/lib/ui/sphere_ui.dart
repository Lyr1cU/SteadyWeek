import 'package:flutter/material.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/l10n/app_localizations.dart';

String sphereLabel(AppLocalizations l10n, LifeSphere sphere) {
  switch (sphere) {
    case LifeSphere.work:
      return l10n.sphereWork;
    case LifeSphere.body:
      return l10n.sphereBody;
    case LifeSphere.social:
      return l10n.sphereSocial;
    case LifeSphere.rest:
      return l10n.sphereRest;
    case LifeSphere.home:
      return l10n.sphereHome;
    case LifeSphere.growth:
      return l10n.sphereGrowth;
  }
}

IconData sphereIcon(LifeSphere sphere) {
  switch (sphere) {
    case LifeSphere.work:
      return Icons.work_outline;
    case LifeSphere.body:
      return Icons.favorite_outline;
    case LifeSphere.social:
      return Icons.people_outline;
    case LifeSphere.rest:
      return Icons.weekend_outlined;
    case LifeSphere.home:
      return Icons.home_outlined;
    case LifeSphere.growth:
      return Icons.school_outlined;
  }
}

/// Повніші іконки для онбордингу / промо-карток сфер.
IconData sphereOnboardingIcon(LifeSphere sphere) {
  switch (sphere) {
    case LifeSphere.work:
      return Icons.work_rounded;
    case LifeSphere.body:
      return Icons.favorite_rounded;
    case LifeSphere.social:
      return Icons.people_rounded;
    case LifeSphere.rest:
      return Icons.beach_access_rounded;
    case LifeSphere.home:
      return Icons.home_rounded;
    case LifeSphere.growth:
      return Icons.school_rounded;
  }
}
