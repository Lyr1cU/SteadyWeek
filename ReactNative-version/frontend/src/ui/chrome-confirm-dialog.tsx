import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { FadeInView, ZoomInView } from './motion/enter';
import { theme } from './theme';

const PANEL_BG = 'rgba(37, 32, 56, 0.98)';
const PANEL_RIM = 'rgba(231, 223, 255, 0.55)';

export function ChromeConfirmDialog({
  visible,
  title,
  message,
  confirmLabel,
  cancelLabel,
  destructive,
  onConfirm,
  onCancel,
}: {
  visible: boolean;
  title: string;
  message: string;
  confirmLabel: string;
  cancelLabel: string;
  destructive?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}) {
  return (
    <Modal visible={visible} transparent animationType="none" onRequestClose={onCancel}>
      <View style={styles.root}>
        <FadeInView ms={160} style={styles.backdropHost}>
          <Pressable style={styles.backdrop} onPress={onCancel} accessibilityLabel="Cancel" />
        </FadeInView>
        <ZoomInView style={styles.panel}>
          <Text style={styles.title}>{title}</Text>
          <Text style={styles.message}>{message}</Text>
          <View style={styles.actions}>
            <Pressable
              onPress={onCancel}
              style={({ pressed }) => [styles.btn, styles.cancelBtn, pressed && styles.pressed]}
            >
              <Text style={styles.cancelText}>{cancelLabel}</Text>
            </Pressable>
            <Pressable
              onPress={onConfirm}
              style={({ pressed }) => [
                styles.btn,
                destructive ? styles.dangerBtn : styles.confirmBtn,
                pressed && styles.pressed,
              ]}
            >
              <Text style={destructive ? styles.dangerText : styles.confirmText}>{confirmLabel}</Text>
            </Pressable>
          </View>
        </ZoomInView>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 28,
  },
  backdropHost: {
    ...StyleSheet.absoluteFill,
  },
  backdrop: {
    ...StyleSheet.absoluteFill,
    backgroundColor: 'rgba(8, 7, 12, 0.45)',
  },
  panel: {
    backgroundColor: PANEL_BG,
    borderRadius: 18,
    borderWidth: 1.5,
    borderColor: PANEL_RIM,
    padding: 20,
    shadowColor: theme.colors.accent,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 16,
    elevation: 12,
  },
  title: { fontSize: 18, fontWeight: '700', color: theme.colors.text },
  message: { marginTop: 10, fontSize: 15, lineHeight: 22, color: theme.colors.textMuted },
  actions: { flexDirection: 'row', gap: 10, marginTop: 20 },
  btn: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  cancelBtn: { backgroundColor: 'rgba(202, 184, 255, 0.08)' },
  confirmBtn: { backgroundColor: theme.colors.accent },
  dangerBtn: { backgroundColor: theme.colors.dangerBg },
  pressed: { opacity: 0.88 },
  cancelText: { color: theme.colors.textMuted, fontWeight: '600' },
  confirmText: { color: theme.colors.accentOn, fontWeight: '700' },
  dangerText: { color: theme.colors.danger, fontWeight: '700' },
});
