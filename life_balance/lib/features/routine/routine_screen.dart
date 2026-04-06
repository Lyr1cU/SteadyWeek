import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/schedule_format.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/life_sphere.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/sphere_ui.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncTemplates = ref.watch(routineTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navRoutine)),
      body: asyncTemplates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.todayEmpty));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              final sphere = LifeSphereStorage.parseOrWork(item.sphere);
              return ListTile(
                leading: Icon(sphereIcon(sphere)),
                title: Text(item.title),
                subtitle: Text(
                  '${formatScheduledTime(l10n, Localizations.localeOf(context), item.scheduledMinuteOfDay)} · '
                  '${sphereLabel(l10n, sphere)} · '
                  '${_weekdaySummary(context, item.weekdays)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l10n.editRoutineItem,
                      onPressed: () =>
                          _openRoutineFormDialog(context, ref, existing: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l10n.delete,
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.delete),
                            content: Text(item.title),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(MaterialLocalizations.of(ctx)
                                    .cancelButtonLabel),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(l10n.delete),
                              ),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          await ref
                              .read(routineRepositoryProvider)
                              .deleteRoutineItem(item.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRoutineFormDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRoutineItem),
      ),
    );
  }

  String _weekdaySummary(BuildContext context, int mask) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];
    final parts = <String>[];
    for (var i = 1; i <= 7; i++) {
      if (routineRunsOnWeekday(mask, i)) {
        parts.add(labels[i - 1]);
      }
    }
    return parts.join(', ');
  }
}

class _RoutineFormResult {
  const _RoutineFormResult({
    required this.title,
    required this.sphere,
    required this.weekdaysMask,
    this.scheduledMinuteOfDay,
  });

  final String title;
  final LifeSphere sphere;
  final int weekdaysMask;
  final int? scheduledMinuteOfDay;
}

Future<void> _openRoutineFormDialog(
  BuildContext context,
  WidgetRef ref, {
  RoutineItem? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final titleController = TextEditingController(text: existing?.title ?? '');
  try {
    final result = await showDialog<_RoutineFormResult>(
      context: context,
      builder: (ctx) {
        var sphere = existing != null
            ? LifeSphereStorage.parseOrWork(existing.sphere)
            : LifeSphere.work;
        var weekdaysMask = existing?.weekdays ?? 0x7f;
        TimeOfDay? pickedTime;
        if (existing?.scheduledMinuteOfDay != null) {
          final m = existing!.scheduledMinuteOfDay!;
          pickedTime = TimeOfDay(hour: m ~/ 60, minute: m % 60);
        }
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(
                existing == null ? l10n.addRoutineItem : l10n.editRoutineItem,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: l10n.routineTitleHint,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.sphereFieldLabel,
                      style: Theme.of(ctx).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    DropdownButton<LifeSphere>(
                      isExpanded: true,
                      value: sphere,
                      items: LifeSphere.values
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(sphereLabel(l10n, s)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => sphere = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.activeDays,
                      style: Theme.of(ctx).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: List.generate(7, (index) {
                        final weekday = index + 1;
                        final selected =
                            routineRunsOnWeekday(weekdaysMask, weekday);
                        final short = [
                          l10n.weekdayMonShort,
                          l10n.weekdayTueShort,
                          l10n.weekdayWedShort,
                          l10n.weekdayThuShort,
                          l10n.weekdayFriShort,
                          l10n.weekdaySatShort,
                          l10n.weekdaySunShort,
                        ][index];
                        return FilterChip(
                          label: Text(short),
                          selected: selected,
                          onSelected: (on) {
                            setState(() {
                              if (on) {
                                weekdaysMask |= weekdayBit(weekday);
                              } else {
                                weekdaysMask &= ~weekdayBit(weekday);
                              }
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.scheduleTimeOptional,
                      style: Theme.of(ctx).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.access_time, size: 18),
                          label: Text(
                            pickedTime == null
                                ? l10n.scheduleSetTime
                                : pickedTime!.format(ctx),
                          ),
                          onPressed: () async {
                            final t = await showTimePicker(
                              context: ctx,
                              initialTime: pickedTime ??
                                  const TimeOfDay(hour: 9, minute: 0),
                            );
                            if (t != null) {
                              setState(() => pickedTime = t);
                            }
                          },
                        ),
                        if (pickedTime != null)
                          TextButton(
                            onPressed: () =>
                                setState(() => pickedTime = null),
                            child: Text(l10n.scheduleNoTime),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty || weekdaysMask == 0) return;
                    final minutes = pickedTime == null
                        ? null
                        : pickedTime!.hour * 60 + pickedTime!.minute;
                    Navigator.pop(
                      ctx,
                      _RoutineFormResult(
                        title: title,
                        sphere: sphere,
                        weekdaysMask: weekdaysMask,
                        scheduledMinuteOfDay: minutes,
                      ),
                    );
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && context.mounted) {
      final repo = ref.read(routineRepositoryProvider);
      if (existing == null) {
        await repo.addRoutineItem(
          title: result.title,
          sphere: result.sphere.id,
          weekdaysMask: result.weekdaysMask,
          scheduledMinuteOfDay: result.scheduledMinuteOfDay,
        );
      } else {
        await repo.updateRoutineItem(
          id: existing.id,
          title: result.title,
          sphere: result.sphere.id,
          weekdaysMask: result.weekdaysMask,
          scheduledMinuteOfDay: result.scheduledMinuteOfDay,
        );
      }
    }
  } finally {
    titleController.dispose();
  }
}
