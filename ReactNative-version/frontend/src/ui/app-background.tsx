import type { ReactNode } from 'react';
import { ImageBackground, StyleSheet, View } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { theme } from './theme';

type AppBackgroundProps = {
  children: ReactNode;
  /** Light JPG + overlay — when we add theme toggle. */
  variant?: 'dark' | 'light';
};

const darkOverlay = ['rgba(0,0,0,0.2)', 'rgba(0,0,0,0.72)'] as const;
const lightOverlay = ['rgba(255,255,255,0.06)', 'rgba(255,255,255,0.28)'] as const;

/** Full-screen nebula JPG + gradient — same stack as Flutter MainShell. */
export function AppBackground({ children, variant = 'dark' }: AppBackgroundProps) {
  const source =
    variant === 'dark' ? theme.assets.onboardingBg : theme.assets.onboardingBgLight;

  return (
    <View style={styles.root}>
      <ImageBackground
        source={source}
        style={StyleSheet.absoluteFill}
        resizeMode="cover"
        accessibilityIgnoresInvertColors
      />
      <LinearGradient
        colors={variant === 'dark' ? [...darkOverlay] : [...lightOverlay]}
        style={StyleSheet.absoluteFill}
        pointerEvents="none"
      />
      <View style={styles.content}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  content: {
    flex: 1,
  },
});
