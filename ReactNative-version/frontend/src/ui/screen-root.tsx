import type { ReactNode } from 'react';
import { View, StyleSheet } from 'react-native';
import { AppBackground } from './app-background';

export function ScreenRoot({
  embedded,
  children,
}: {
  embedded?: boolean;
  children: ReactNode;
}) {
  if (embedded) {
    return <View style={styles.embedded}>{children}</View>;
  }
  return <AppBackground>{children}</AppBackground>;
}

const styles = StyleSheet.create({
  embedded: { flex: 1 },
});
