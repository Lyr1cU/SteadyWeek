import { Ionicons } from '@expo/vector-icons';
import DateTimePicker, {
  DateTimePickerAndroid,
  type DateTimePickerEvent,
} from '@react-native-community/datetimepicker';
import { createElement, useState } from 'react';
import { Modal, Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import { dateFromMinuteOfDay, formatMinuteOfDay, minuteFromDate } from '../../logic/time-of-day';
import { strings } from '../../l10n';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

export function RoutineTimeField({
  minute,
  onChange,
}: {
  minute: number | null;
  onChange: (minute: number | null) => void;
}) {
  const copy = strings().routine;
  const [sheetOpen, setSheetOpen] = useState(false);
  const [draftDate, setDraftDate] = useState(() => dateFromMinuteOfDay(minute ?? 9 * 60));

  const label = minute == null ? copy.timeTapToSet : formatMinuteOfDay(minute);
  const muted = minute == null;

  const openPicker = () => {
    setDraftDate(dateFromMinuteOfDay(minute ?? 9 * 60));
    if (Platform.OS === 'android') {
      DateTimePickerAndroid.open({
        value: dateFromMinuteOfDay(minute ?? 9 * 60),
        mode: 'time',
        is24Hour: true,
        display: 'clock',
        onChange: (event: DateTimePickerEvent, date?: Date) => {
          if (event.type === 'set' && date) {
            onChange(minuteFromDate(date));
          }
        },
      });
      return;
    }
    setSheetOpen(true);
  };

  const commitSheet = () => {
    onChange(minuteFromDate(draftDate));
    setSheetOpen(false);
  };

  return (
    <>
      <AnimatedPressable onPress={openPicker} style={styles.field}>
        <Text style={[styles.fieldText, muted && styles.fieldPlaceholder]}>{label}</Text>
        <Ionicons name="time-outline" size={20} color={theme.colors.accentMuted} />
      </AnimatedPressable>
      {minute != null ? (
        <Pressable onPress={() => onChange(null)} hitSlop={8} style={styles.clearBtn}>
          <Text style={styles.clearText}>{copy.timeClear}</Text>
        </Pressable>
      ) : null}

      {Platform.OS === 'web' || Platform.OS === 'ios' ? (
        <Modal visible={sheetOpen} transparent animationType="fade" onRequestClose={() => setSheetOpen(false)}>
          <View style={styles.sheetBackdrop}>
            <Pressable style={StyleSheet.absoluteFill} onPress={() => setSheetOpen(false)} />
            <View style={styles.sheet}>
              <Text style={styles.sheetTitle}>{copy.selectTime}</Text>
              {Platform.OS === 'web' ? (
                <View style={styles.webPickerHost}>
                  {createElement('input', {
                    type: 'time',
                    value: formatMinuteOfDay(minuteFromDate(draftDate)),
                    onChange: (event: { target: { value: string } }) => {
                      const next = event.target.value;
                      if (!next) {
                        return;
                      }
                      const [h, m] = next.split(':').map(Number);
                      if (Number.isFinite(h) && Number.isFinite(m)) {
                        setDraftDate(dateFromMinuteOfDay(h * 60 + m));
                      }
                    },
                    style: {
                      width: '100%',
                      padding: '10px 12px',
                      borderRadius: 10,
                      border: '1px solid rgba(202, 184, 255, 0.35)',
                      background: 'rgba(8, 7, 14, 0.35)',
                      color: '#f5f0ff',
                      fontSize: 15,
                      fontFamily: 'inherit',
                    },
                  })}
                </View>
              ) : (
                <DateTimePicker
                  value={draftDate}
                  mode="time"
                  display="spinner"
                  onChange={(_, date) => {
                    if (date) {
                      setDraftDate(date);
                    }
                  }}
                  themeVariant="dark"
                  accentColor={theme.colors.accent}
                />
              )}
              <View style={styles.sheetActions}>
                <Pressable onPress={() => setSheetOpen(false)} style={styles.sheetSecondary}>
                  <Text style={styles.sheetSecondaryText}>{copy.cancel}</Text>
                </Pressable>
                <Pressable onPress={commitSheet} style={styles.sheetPrimary}>
                  <Text style={styles.sheetPrimaryText}>{copy.timeDone}</Text>
                </Pressable>
              </View>
            </View>
          </View>
        </Modal>
      ) : null}
    </>
  );
}

const styles = StyleSheet.create({
  field: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.2)',
    borderRadius: theme.radius.md,
    paddingHorizontal: 12,
    paddingVertical: 12,
    backgroundColor: 'rgba(8, 7, 14, 0.35)',
  },
  fieldText: {
    color: theme.colors.text,
    fontSize: 16,
    fontWeight: '600',
  },
  fieldPlaceholder: {
    color: theme.colors.textSubtle,
    fontWeight: '500',
  },
  clearBtn: {
    alignSelf: 'flex-start',
    marginTop: 6,
  },
  clearText: {
    color: theme.colors.accent,
    fontWeight: '600',
    fontSize: 13,
  },
  webPickerHost: {
    width: '100%',
  },
  sheetBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.55)',
    justifyContent: 'flex-end',
  },
  sheet: {
    backgroundColor: theme.colors.surface,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 28,
  },
  sheetTitle: {
    color: theme.colors.text,
    fontSize: 17,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: 8,
  },
  sheetActions: {
    flexDirection: 'row',
    gap: 12,
    marginTop: 12,
  },
  sheetSecondary: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
  },
  sheetSecondaryText: {
    color: theme.colors.textMuted,
    fontWeight: '600',
  },
  sheetPrimary: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    backgroundColor: theme.colors.accent,
    borderRadius: theme.radius.md,
  },
  sheetPrimaryText: {
    color: theme.colors.accentOn,
    fontWeight: '700',
  },
});
