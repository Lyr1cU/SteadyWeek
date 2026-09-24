import { useCallback, useEffect, useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { RoutineItem, RoutineItemInput } from '../../domain/models';
import { formatMinuteOfDay, parseTimeInput } from '../../logic/time-of-day';
import { strings } from '../../l10n';
import { ChromeConfirmDialog } from '../../ui/chrome-confirm-dialog';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { RoutineEditorModal } from './routine-editor-modal';
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
  const copy = strings().routine;
  const [items, setItems] = useState<RoutineItem[]>([]);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editorOpen, setEditorOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [draft, setDraft] = useState<RoutineItemInput>(emptyDraft);
  const [timeText, setTimeText] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<RoutineItem | null>(null);

  const reload = useCallback(async () => {
    setItems(await routine.listTemplates());
  }, [routine]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  const closeEditor = () => {
    setEditorOpen(false);
    setEditingId(null);
    setDraft(emptyDraft());
    setTimeText('');
    setError(null);
    setSaving(false);
  };

  const openAdd = () => {
    setEditingId(null);
    setDraft(emptyDraft());
    setTimeText('');
    setError(null);
    setEditorOpen(true);
  };

  const startEdit = (item: RoutineItem) => {
    setEditingId(item.id);
    setDraft(draftFromItem(item));
    setTimeText(
      item.scheduledMinuteOfDay == null ? '' : formatMinuteOfDay(item.scheduledMinuteOfDay),
    );
    setError(null);
    setEditorOpen(true);
  };

  const saveDraft = async () => {
    if (!draft.title.trim()) {
      setError(copy.errorTitleRequired);
      return;
    }
    if (draft.weekdays === 0) {
      setError(copy.errorWeekdayRequired);
      return;
    }

    const parsedTime = parseTimeInput(timeText);
    if (timeText.trim() && parsedTime == null) {
      setError(copy.errorTimeInvalid);
      return;
    }

    const payload: RoutineItemInput = {
      ...draft,
      scheduledMinuteOfDay: parsedTime,
    };

    setSaving(true);
    try {
      if (editingId) {
        await routine.updateItem(editingId, payload);
      } else {
        await routine.createItem(payload);
      }
      closeEditor();
      await reload();
    } catch (e) {
      setError(e instanceof Error ? e.message : copy.errorSaveFailed);
    } finally {
      setSaving(false);
    }
  };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    const id = deleteTarget.id;
    setDeleteTarget(null);
    try {
      await routine.deleteItem(id);
      if (editingId === id) {
        closeEditor();
      }
      await reload();
    } catch (e) {
      setError(e instanceof Error ? e.message : copy.errorDeleteFailed);
      setEditorOpen(true);
    }
  };

  return (
    <>
      <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
        <StaggerFadeIn index={0}>
          <Text style={styles.title}>{copy.screenTitle}</Text>
          <View style={styles.subHeader}>
            <Text style={styles.subtitle}>{copy.subtitle}</Text>
            <AnimatedPressable onPress={openAdd} style={styles.addPill}>
              <Text style={styles.addPillText}>+ {copy.addItem}</Text>
            </AnimatedPressable>
          </View>
        </StaggerFadeIn>
        {items.length > 0 ? (
          <Text style={styles.count}>{copy.templateCount(items.length)}</Text>
        ) : null}

        <RoutineList
          items={items}
          editingId={editingId}
          onEdit={startEdit}
          onDelete={setDeleteTarget}
          onExpandAdd={openAdd}
        />
      </ScrollView>

      <RoutineEditorModal
        visible={editorOpen}
        editing={editingId != null}
        draft={draft}
        timeText={timeText}
        error={error}
        saving={saving}
        onDraft={setDraft}
        onTimeText={setTimeText}
        onClose={closeEditor}
        onSave={() => void saveDraft()}
      />

      <ChromeConfirmDialog
        visible={deleteTarget != null}
        title={copy.deleteTitle}
        message={deleteTarget ? copy.deleteMessage(deleteTarget.title) : ''}
        confirmLabel={copy.deleteConfirm}
        cancelLabel={copy.cancel}
        destructive
        onConfirm={() => void confirmDelete()}
        onCancel={() => setDeleteTarget(null)}
      />
    </>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 24,
  },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subHeader: {
    marginTop: 6,
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 10,
  },
  subtitle: { color: theme.colors.textMuted, flex: 1, minWidth: 120 },
  addPill: {
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: theme.radius.pill,
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.35)',
    backgroundColor: 'rgba(53, 45, 85, 0.45)',
  },
  addPillText: { color: theme.colors.accent, fontWeight: '700', fontSize: 14 },
  count: { marginTop: 8, marginBottom: 12, color: theme.colors.textSubtle, fontWeight: '600', fontSize: 14 },
});
