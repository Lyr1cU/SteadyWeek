import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

export function ProfileMenuRow({
  label,
  subtitle,
  icon,
  onPress,
  danger,
  last,
}: {
  label: string;
  subtitle?: string;
  icon: keyof typeof Ionicons.glyphMap;
  onPress: () => void;
  danger?: boolean;
  last?: boolean;
}) {
  return (
    <AnimatedPressable
      onPress={onPress}
      style={[styles.row, !last && styles.rowBorder]}
    >
      <View style={styles.iconWrap}>
        <Ionicons
          name={icon}
          size={20}
          color={danger ? theme.colors.danger : theme.colors.accentMuted}
        />
      </View>
      <View style={styles.textCol}>
        <Text style={[styles.label, danger && styles.labelDanger]}>{label}</Text>
        {subtitle ? <Text style={styles.subtitle}>{subtitle}</Text> : null}
      </View>
      {!danger ? (
        <Ionicons name="chevron-forward" size={18} color={theme.colors.textSubtle} />
      ) : null}
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    gap: 12,
  },
  rowBorder: {
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: 'rgba(202, 184, 255, 0.15)',
  },
  iconWrap: { width: 28, alignItems: 'center' },
  textCol: { flex: 1, minWidth: 0 },
  label: { fontSize: 16, fontWeight: '600', color: theme.colors.text },
  labelDanger: { color: theme.colors.danger },
  subtitle: { marginTop: 2, fontSize: 13, color: theme.colors.textMuted, lineHeight: 18 },
});
