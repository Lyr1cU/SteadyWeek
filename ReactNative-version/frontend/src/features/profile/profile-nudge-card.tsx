import { Pressable, StyleSheet, Text, View } from 'react-native';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function ProfileNudgeCard({ onAssistant }: { onAssistant: () => void }) {
  const copy = strings().profile;

  return (
    <GlassSurface style={styles.card}>
      <View style={styles.rim}>
        <Text style={styles.title}>{copy.nudgeTitle}</Text>
        <Text style={styles.body}>{copy.nudgeBody}</Text>
        <Pressable
          onPress={onAssistant}
          style={({ pressed }) => [styles.button, pressed && styles.pressed]}
        >
          <Text style={styles.buttonText}>{copy.talkToAssistant}</Text>
        </Pressable>
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: 10,
    borderRadius: theme.radius.lg,
    padding: 0,
    borderWidth: 1.5,
    borderColor: 'rgba(255, 193, 7, 0.45)',
  },
  rim: {
    padding: 16,
    backgroundColor: 'rgba(255, 193, 7, 0.08)',
    borderRadius: theme.radius.lg - 2,
  },
  title: {
    fontSize: 17,
    fontWeight: '700',
    color: theme.colors.warningText,
    marginBottom: 8,
  },
  body: { color: theme.colors.warningText, lineHeight: 22, marginBottom: 14, opacity: 0.95 },
  button: {
    alignSelf: 'flex-start',
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: theme.radius.md,
    backgroundColor: theme.colors.accent,
  },
  pressed: { opacity: 0.88 },
  buttonText: { fontWeight: '700', color: theme.colors.accentOn, fontSize: 15 },
});
