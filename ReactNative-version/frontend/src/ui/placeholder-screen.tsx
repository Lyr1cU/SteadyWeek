import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';

export function PlaceholderScreen({
  title,
  subtitle,
  onBack,
}: {
  title: string;
  subtitle: string;
  onBack?: () => void;
}) {
  return (
    <View style={styles.wrap}>
      {onBack ? (
        <Pressable onPress={onBack} style={styles.back}>
          <Text style={styles.backText}>Back</Text>
        </Pressable>
      ) : null}
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.sub}>{subtitle}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: {
    flex: 1,
    padding: theme.spacing.screenX,
    justifyContent: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: theme.colors.text,
    marginBottom: 8,
  },
  sub: {
    fontSize: 16,
    lineHeight: 22,
    color: theme.colors.textMuted,
  },
  back: {
    position: 'absolute',
    top: theme.spacing.screenTop,
    left: 20,
  },
  backText: {
    fontSize: 16,
    color: theme.colors.accent,
    fontWeight: '600',
  },
});
