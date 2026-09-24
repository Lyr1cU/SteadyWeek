import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';
import { theme } from '../../ui/theme';

export function ProfileInfoRow({
  label,
  subtitle,
  icon,
  last,
}: {
  label: string;
  subtitle?: string;
  icon: keyof typeof Ionicons.glyphMap;
  last?: boolean;
}) {
  return (
    <View style={[styles.row, !last && styles.rowBorder]}>
      <View style={styles.iconWrap}>
        <Ionicons name={icon} size={20} color={theme.colors.accentMuted} />
      </View>
      <View style={styles.textCol}>
        <Text style={styles.label}>{label}</Text>
        {subtitle ? <Text style={styles.subtitle}>{subtitle}</Text> : null}
      </View>
    </View>
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
  subtitle: { marginTop: 2, fontSize: 13, color: theme.colors.textMuted, lineHeight: 18 },
});
