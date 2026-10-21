import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import type { RoutineItemInput } from '../../domain/models';
import { strings } from '../../l10n';
import { ChromeBottomSheet } from '../../ui/chrome-bottom-sheet';
import { theme } from '../../ui/theme';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';
import { RoutineFormFields } from './routine-form-fields';

export function RoutineEditorModal({
  visible,
  editing,
  draft,
  error,
  saving,
  onDraft,
  onClose,
  onSave,
}: {
  visible: boolean;
  editing: boolean;
  draft: RoutineItemInput;
  error: string | null;
  saving: boolean;
  onDraft: (next: RoutineItemInput) => void;
  onClose: () => void;
  onSave: () => void;
}) {
  const copy = strings().routine;
  const keyboardInset = useKeyboardBottomInset();

  return (
    <ChromeBottomSheet
      visible={visible}
      onClose={onClose}
      backdropLabel={copy.cancel}
      sheetStyle={[
        styles.sheet,
        keyboardInset > 0 && { marginBottom: keyboardInset, maxHeight: '92%' },
      ]}
    >
      <ScrollView
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
        bounces={false}
      >
        <Text style={styles.heading}>{editing ? copy.editFormTitle : copy.addItem}</Text>
        <RoutineFormFields draft={draft} error={error} onDraft={onDraft} />
        <View style={styles.actions}>
          <Pressable onPress={onClose} style={styles.secondaryBtn}>
            <Text style={styles.secondaryText}>{copy.cancel}</Text>
          </Pressable>
          <Pressable
            onPress={onSave}
            style={[styles.primaryBtn, saving && styles.primaryDisabled]}
            disabled={saving}
          >
            <Text style={styles.primaryText}>
              {saving ? '…' : editing ? copy.saveChanges : copy.addItem}
            </Text>
          </Pressable>
        </View>
      </ScrollView>
    </ChromeBottomSheet>
  );
}

const styles = StyleSheet.create({
  sheet: {
    backgroundColor: theme.colors.surface,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: theme.spacing.screenX,
    paddingBottom: 32,
    maxHeight: '88%',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.2)',
  },
  heading: { fontSize: 22, fontWeight: '700', color: theme.colors.text, marginBottom: 4 },
  actions: { flexDirection: 'row', gap: 12, marginTop: 20, marginBottom: 8 },
  secondaryBtn: { flex: 1, padding: 14, alignItems: 'center' },
  secondaryText: { color: theme.colors.textMuted, fontWeight: '600' },
  primaryBtn: {
    flex: 1,
    padding: 14,
    alignItems: 'center',
    backgroundColor: theme.colors.accent,
    borderRadius: theme.radius.md,
  },
  primaryDisabled: { opacity: 0.7 },
  primaryText: { color: theme.colors.accentOn, fontWeight: '700' },
});
