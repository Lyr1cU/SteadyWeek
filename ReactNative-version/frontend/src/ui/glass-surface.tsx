import type { ReactNode } from 'react';
import { StyleSheet, View, type ViewStyle } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { theme } from './theme';

type GlassSurfaceProps = {
  children: ReactNode;
  style?: ViewStyle;
};

/** Frosted card on nebula — matches Flutter `ChromeCard` (gradient + rim, no BackdropFilter). */
const GLASS_BORDER = 'rgba(231, 223, 255, 0.42)';
const GLASS_GRADIENT = [
  'rgba(255, 255, 255, 0.2)',
  'rgba(255, 255, 255, 0.08)',
  'rgba(202, 184, 255, 0.1)',
] as const;

const PADDING_KEYS = [
  'padding',
  'paddingHorizontal',
  'paddingVertical',
  'paddingTop',
  'paddingBottom',
  'paddingLeft',
  'paddingRight',
] as const satisfies readonly (keyof ViewStyle)[];

function splitShellStyle(style?: ViewStyle): { shell: ViewStyle; padding: ViewStyle } {
  const flat = StyleSheet.flatten(style) ?? {};
  const shell: ViewStyle = {};
  const padding: ViewStyle = {};

  for (const [key, value] of Object.entries(flat)) {
    if (value === undefined) {
      continue;
    }
    if ((PADDING_KEYS as readonly string[]).includes(key)) {
      (padding as Record<string, unknown>)[key] = value;
    } else {
      (shell as Record<string, unknown>)[key] = value;
    }
  }

  return { shell, padding };
}

export function GlassSurface({ children, style }: GlassSurfaceProps) {
  const { shell, padding } = splitShellStyle(style);
  const hasPadding = Object.keys(padding).length > 0;

  return (
    <View style={[styles.shell, shell]}>
      <LinearGradient
        colors={[...GLASS_GRADIENT]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.fill}
      >
        {hasPadding ? <View style={padding}>{children}</View> : children}
      </LinearGradient>
    </View>
  );
}

const styles = StyleSheet.create({
  shell: {
    borderRadius: theme.radius.lg,
    borderWidth: 1,
    borderColor: GLASS_BORDER,
    overflow: 'hidden',
    backgroundColor: 'transparent',
  },
  fill: {
    alignSelf: 'stretch',
    borderRadius: theme.radius.lg - 1,
  },
});
