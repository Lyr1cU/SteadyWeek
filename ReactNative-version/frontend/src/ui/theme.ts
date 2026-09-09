/**
 * Design tokens — dark + lavender.
 * Source: Flutter `flutter-version/lib/ui/app_theme.dart` + `design/` mockups.
 * Nebula JPG via `AppBackground`; glass/glow — phase 6.
 */
export const theme = {
  assets: {
    onboardingBg: require('../../assets/onboarding_bg.jpg'),
    onboardingBgLight: require('../../assets/onboarding_bg_light.jpg'),
  } as const,

  colors: {
    background: '#0C0C12',
    surface: '#14141E',
    surfaceHigh: '#1C1C2A',
    surfaceHighest: '#242433',
    border: '#2E2E42',
    outline: '#5D5D74',

    accent: '#CAB8FF',
    accentOn: '#1A1530',
    accentContainer: '#352D55',
    accentMuted: '#B4A3E8',

    text: '#E8E6F2',
    textMuted: '#C4C1D4',
    textSubtle: '#8A8799',

    success: '#86EFAC',
    successBg: '#14532D',
    successText: '#DCFCE7',

    warning: '#FCD34D',
    warningBg: '#713F12',
    warningText: '#FEF3C7',

    danger: '#FCA5A5',
    dangerBg: '#450A0A',
    dangerText: '#FEE2E2',

    /** Tab bar / chrome on top of nebula background. */
    chromeSurface: 'rgba(20, 20, 30, 0.92)',
  },

  radius: {
    sm: 10,
    md: 12,
    lg: 18,
    pill: 999,
  },

  spacing: {
    screenX: 24,
    screenTop: 56,
    stack: 12,
    section: 20,
  },
} as const;

export type AppTheme = typeof theme;
