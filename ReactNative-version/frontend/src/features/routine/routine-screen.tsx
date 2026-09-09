import { useCallback, useEffect, useState } from 'react';
import { ScrollView, StyleSheet, Text } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { RoutineItem, RoutineItemInput } from '../../domain/models';
import { formatMinuteOfDay, parseTimeInput } from '../../logic/time-of-day';
import { theme } from '../../ui/theme';
import { RoutineForm } from './routine-form';
import { RoutineList } from './routine-list';

const emptyDraft = (): RoutineItemInput => ({
  title: '',
  sphere: 'work',
  weekdays: 31,
  effort: 'medium',
  isOptional: false,
  scheduledMinuteOfDay: null,
});

function draftFromItem(item: RoutineItem): RoutineItemInput {
  return {
    title: item.title,
    sphere: item.sphere,
    weekdays: item.weekdays,
    effort: item.effort,
    isOptional: item.isOptional,
    scheduledMinuteOfDay: item.scheduledMinuteOfDay,
  };
}

export function RoutineScreen() {
  const { routine } = useRepos();
  const { syncRevision } = useSync();
  const [items, setItems] = useState<RoutineItem[]>([]);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [draft, setDraft] = useState<RoutineItemInput>(emptyDraft);
  const [timeText, setTimeText] = useState('');
  const [error, setError] = useState<string | null>(null);

  const reload = useCallback(async () => {
    setItems(await routine.listTemplates());
  }, [routine]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  const resetForm = () => {
    setEditingId(null);
    setDraft(emptyDraft());
    setTimeText('');
    setError(null);
  };

  const startEdit = (item: RoutineItem) => {
    setEditingId(item.id);
    setDraft(draftFromItem(item));
    setTimeText(
      item.scheduledMinuteOfDay == null ? '' : formatMinuteOfDay(item.scheduledMinuteOfDay),
    );
    setError(null);
  };

  const saveDraft = async () => {
    if (!draft.title.trim()) {
      setError('Title is required.');
      return;
    }
    if (draft.weekdays === 0) {
      setError('Pick at least one weekday.');
      return;
    }

    const parsedTime = parseTimeInput(timeText);
    if (timeText.trim() && parsedTime == null) {
      setError('Time must be HH:MM (24h) or empty.');
      return;
    }

    const payload: RoutineItemInput = {
      ...draft,
      scheduledMinuteOfDay: parsedTime,
    };

    try {
      if (editingId) {
        await routine.updateItem(editingId, payload);
      } else {
        await routine.createItem(payload);
      }
      resetForm();
      await reload();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Could not save item.');
    }
  };

  const removeItem = async (id: string) => {
    try {
      await routine.deleteItem(id);
      if (editingId === id) {
        resetForm();
      }
      await reload();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Could not delete item.');
    }
  };

  return (
    <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
      <Text style={styles.title}>Routine</Text>
      <Text style={styles.subtitle}>Weekly template: title, weekdays, time, sphere, effort.</Text>
      <RoutineList
        items={items}
        editingId={editingId}
        onEdit={startEdit}
        onDelete={(id) => void removeItem(id)}
      />
      <RoutineForm
        draft={draft}
        timeText={timeText}
        error={error}
        editing={editingId != null}
        onDraft={setDraft}
        onTimeText={setTimeText}
        onSave={() => void saveDraft()}
        onCancel={resetForm}
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subtitle: { marginTop: 6, marginBottom: 20, color: theme.colors.textMuted },
});
