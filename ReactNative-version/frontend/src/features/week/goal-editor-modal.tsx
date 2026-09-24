import { useEffect, useState } from 'react';
import {
  Modal,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { LIFE_SPHERES, type LifeSphereId } from '../../domain/life-sphere';
import type { WeeklyGoal, WeeklyGoalInput } from '../../domain/models';
import { FadeInDownView, FadeInView } from '../../ui/motion/enter';
import { theme } from '../../ui/theme';
import { sphereLabel } from '../../ui/sphere-ui';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';

export function GoalEditorModal({
  visible,
  weekKey,
  editing,
  onClose,
  onSave,
}: {
  visible: boolean;
  weekKey: string;
  editing: WeeklyGoal | null;
  onClose: () => void;
  onSave: (input: WeeklyGoalInput) => Promise<void>;
}) {
  const [title, setTitle] = useState('');
  const [sphere, setSphere] = useState<LifeSphereId>('growth');
  const [targetText, setTargetText] = useState('1');
  const [saving, setSaving] = useState(false);
  const keyboardInset = useKeyboardBottomInset();

  useEffect(() => {
    if (!visible) return;
    setTitle(editing?.title ?? '');
    setSphere(editing?.sphere ?? 'growth');
    setTargetText(String(editing?.targetCount ?? 1));
  }, [visible, editing]);

  const submit = async () => {
    const trimmed = title.trim();
    if (!trimmed) return;
    const targetCount = Math.max(1, parseInt(targetText, 10) || 1);
    setSaving(true);
    try {
      await onSave({ weekKey, sphere, title: trimmed, targetCount });
      onClose();
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal visible={visible} animationType="none" transparent onRequestClose={onClose}>
      <View style={styles.backdrop}>
        <FadeInView style={styles.backdropFill} />
        <FadeInDownView
          style={[
            styles.sheet,
            keyboardInset > 0 && { marginBottom: keyboardInset, maxHeight: '85%' },
          ]}
        >
          <ScrollView
            keyboardShouldPersistTaps="handled"
            showsVerticalScrollIndicator={false}
            bounces={false}
          >
          <Text style={styles.heading}>{editing ? 'Edit goal' : 'New weekly goal'}</Text>
          <Text style={styles.label}>Title</Text>
          <TextInput
            style={styles.input}
            value={title}
            onChangeText={setTitle}
            placeholder="What do you want this week?"
            placeholderTextColor={theme.colors.textSubtle}
          />
          <Text style={styles.label}>Sphere</Text>
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.spheres}>
            {LIFE_SPHERES.map((id) => (
              <Pressable
                key={id}
                onPress={() => setSphere(id)}
                style={[styles.sphereChip, sphere === id && styles.sphereChipOn]}
              >
                <Text style={[styles.sphereText, sphere === id && styles.sphereTextOn]}>
                  {sphereLabel(id)}
                </Text>
              </Pressable>
            ))}
          </ScrollView>
          <Text style={styles.label}>Target count</Text>
          <TextInput
            style={styles.input}
            value={targetText}
            onChangeText={setTargetText}
            keyboardType="number-pad"
          />
          <View style={styles.actions}>
            <Pressable onPress={onClose} style={styles.secondaryBtn}>
              <Text style={styles.secondaryText}>Cancel</Text>
            </Pressable>
            <Pressable onPress={() => void submit()} style={styles.primaryBtn} disabled={saving}>
              <Text style={styles.primaryText}>{saving ? 'Saving…' : 'Save'}</Text>
            </Pressable>
          </View>
          </ScrollView>
        </FadeInDownView>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  backdropFill: {
    ...StyleSheet.absoluteFill,
    backgroundColor: 'rgba(0,0,0,0.55)',
  },
  sheet: {
    backgroundColor: theme.colors.surface,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: theme.spacing.screenX,
    paddingBottom: 32,
  },
  heading: { fontSize: 22, fontWeight: '700', color: theme.colors.text, marginBottom: 16 },
  label: { color: theme.colors.textMuted, marginBottom: 6, marginTop: 8 },
  input: {
    backgroundColor: theme.colors.surfaceHigh,
    borderRadius: theme.radius.md,
    padding: 12,
    color: theme.colors.text,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  spheres: { flexGrow: 0, marginBottom: 8 },
  sphereChip: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 999,
    marginRight: 8,
    backgroundColor: theme.colors.surfaceHigh,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  sphereChipOn: { backgroundColor: theme.colors.accentContainer, borderColor: theme.colors.accent },
  sphereText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 13 },
  sphereTextOn: { color: theme.colors.accent },
  actions: { flexDirection: 'row', gap: 12, marginTop: 20 },
  secondaryBtn: { flex: 1, padding: 14, alignItems: 'center' },
  secondaryText: { color: theme.colors.textMuted, fontWeight: '600' },
  primaryBtn: {
    flex: 1,
    padding: 14,
    alignItems: 'center',
    backgroundColor: theme.colors.accent,
    borderRadius: theme.radius.md,
  },
  primaryText: { color: theme.colors.accentOn, fontWeight: '700' },
});
