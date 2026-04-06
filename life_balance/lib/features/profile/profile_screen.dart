import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/core/app_theme_preference.dart';
import 'package:life_balance/data/drift/local_db_backup.dart';
import 'package:life_balance/debug/debug_playtest.dart';
import 'package:life_balance/domain/shop_catalog.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/notifications/close_day_reminder_sync.dart';
import 'package:life_balance/notifications/notification_service.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/profile_avatar_frame.dart';
import 'package:life_balance/ui/profile_header_decoration.dart';
import 'package:life_balance/ui/profile_name_style.dart';
import 'package:life_balance/ui/shop_item_strings.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';

/// Dev / profile builds only — hidden in release (`flutter build`).
Widget _playtestToolsCard(BuildContext context, WidgetRef ref) {
  if (kReleaseMode) return const SizedBox.shrink();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 8),
      Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bug_report_outlined,
                    size: 22,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Debug playtest',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Non-release builds only: add XP, unlock streak shop items, '
                'set a test name.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              if (!kIsWeb)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await NotificationService.instance.showDebugTestNow();
                    },
                    child: const Text('Test notification now'),
                  ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () async {
                      await debugGrantXp(
                        ref.read(appDatabaseProvider),
                        500,
                      );
                    },
                    child: const Text('+500 XP'),
                  ),
                  FilledButton.tonal(
                    onPressed: () async {
                      await debugGrantXp(
                        ref.read(appDatabaseProvider),
                        5000,
                      );
                    },
                    child: const Text('+5000 XP'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () async {
                  await debugSetBestStreak(
                    ref.read(appDatabaseProvider),
                    10,
                  );
                },
                child: const Text('Best streak = 10 (Ember frame)'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final controller = TextEditingController(text: 'Alex');
                  try {
                    final name = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Test display name'),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(ctx, controller.text.trim()),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                    if (!context.mounted) return;
                    if (name != null && name.isNotEmpty) {
                      await ref
                          .read(userDisplayNameProvider.notifier)
                          .setName(name);
                    }
                  } finally {
                    controller.dispose();
                  }
                },
                child: const Text('Set test name'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (stats) {
          return ref.watch(ownedShopItemIdsProvider).when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (owned) {
                  final reminder = ref.watch(closeDayReminderProvider);
                  final xp = stats?.totalXp ?? 0;
                  final streak = stats?.currentStreak ?? 0;
                  final best = stats?.bestStreak ?? 0;
                  final themePref = ref.watch(themePreferenceProvider);
                  final displayName = ref.watch(userDisplayNameProvider);
                  final effectiveBg =
                      ref.watch(effectiveProfileBackgroundIdProvider);
                  final effectiveFrame =
                      ref.watch(effectiveProfileAvatarFrameIdProvider);
                  final effectiveNameStyle =
                      ref.watch(effectiveProfileNameStyleIdProvider);

                  final ownedProfileBgs = kShopCatalog
                      .where(
                        (e) =>
                            e.category ==
                                ShopItemCategory.profileBackground &&
                            owned.contains(e.id),
                      )
                      .toList();
                  final ownedFrames = kShopCatalog
                      .where(
                        (e) =>
                            e.category == ShopItemCategory.frame &&
                            owned.contains(e.id),
                      )
                      .toList();
                  final ownedNameStyles = kShopCatalog
                      .where(
                        (e) =>
                            e.category == ShopItemCategory.nameStyle &&
                            owned.contains(e.id),
                      )
                      .toList();
                  final headerNameBase =
                      Theme.of(context).textTheme.titleMedium ??
                          Theme.of(context).textTheme.titleLarge ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          );

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: displayName != null && displayName.isNotEmpty
                            ? 218
                            : 188,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DecoratedBox(
                              decoration: profileHeaderDecoration(
                                context,
                                effectiveBg,
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  profileAvatarFrame(
                                    frameId: effectiveFrame,
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withValues(alpha: 0.22),
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        size: 46,
                                        color: profileHeaderAvatarIconColor(
                                          context,
                                          effectiveBg,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (displayName != null &&
                                      displayName.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: profileStyledDisplayName(
                                        name: displayName,
                                        nameStyleId: effectiveNameStyle,
                                        baseStyle: headerNameBase.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              profileHeaderDefaultNameColor(
                                            context,
                                            effectiveBg,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.cloud_outlined),
                                title: Text(l10n.profileOpenAuth),
                                subtitle: Text(l10n.authSubtitle),
                                onTap: () => context.push('/auth'),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.smart_toy_outlined,
                                ),
                                title: Text(l10n.assistantScreenTitle),
                                subtitle: Text(l10n.assistantScreenTileSubtitle),
                                onTap: () => context.push('/assistant'),
                              ),
                            ),
                            if (!kIsWeb)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.save_alt_outlined,
                                            size: 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              l10n.profileDbBackupTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        l10n.profileDbBackupSubtitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      FilledButton.tonalIcon(
                                        icon: const Icon(
                                          Icons.ios_share_outlined,
                                          size: 20,
                                        ),
                                        label: Text(l10n.profileDbBackupExport),
                                        onPressed: () async {
                                          try {
                                            final file =
                                                await createDatabaseExportCopy(
                                              ref.read(appDatabaseProvider),
                                            );
                                            if (!context.mounted) return;
                                            await Share.shareXFiles(
                                              [XFile(file.path)],
                                              subject: l10n
                                                  .profileDbBackupShareSubject,
                                            );
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n
                                                        .profileDbBackupExportError(
                                                      '$e',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      OutlinedButton.icon(
                                        icon: const Icon(
                                          Icons.restore_outlined,
                                          size: 20,
                                        ),
                                        label: Text(l10n.profileDbBackupImport),
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text(
                                                l10n
                                                    .profileDbBackupImportConfirmTitle,
                                              ),
                                              content: Text(
                                                l10n
                                                    .profileDbBackupImportConfirmBody,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                    ctx,
                                                    false,
                                                  ),
                                                  child: Text(
                                                    l10n.actionCancel,
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                    ctx,
                                                    true,
                                                  ),
                                                  child: Text(
                                                    l10n
                                                        .profileDbBackupRestart,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm != true) return;
                                          if (!context.mounted) return;
                                          final pick = await FilePicker
                                              .platform
                                              .pickFiles(
                                            type: FileType.any,
                                            withData: true,
                                          );
                                          if (!context.mounted) return;
                                          if (pick == null ||
                                              pick.files.isEmpty) {
                                            return;
                                          }
                                          final bytes =
                                              pick.files.single.bytes;
                                          if (bytes == null) {
                                            return;
                                          }
                                          try {
                                            await stageDatabaseRestore(bytes);
                                            if (!context.mounted) return;
                                            Restart.restartApp();
                                          } on FormatException {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n
                                                        .profileDbBackupNotSqlite,
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n
                                                        .profileDbBackupExportError(
                                                      '$e',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            _playtestToolsCard(context, ref),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        l10n.profileBackgroundSection,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ChoiceChip(
                                          label: Text(
                                            l10n.profileCosmeticDefault,
                                          ),
                                          selected: effectiveBg == null,
                                          onSelected: (_) async {
                                            await ref
                                                .read(
                                                  profileBackgroundIdProvider
                                                      .notifier,
                                                )
                                                .setBackgroundId(null);
                                          },
                                        ),
                                        for (final def in ownedProfileBgs)
                                          ChoiceChip(
                                            label: Text(
                                              shopItemStrings(
                                                l10n,
                                                def.id,
                                              ).title,
                                            ),
                                            selected:
                                                effectiveBg == def.id,
                                            onSelected: (_) async {
                                              await ref
                                                  .read(
                                                    profileBackgroundIdProvider
                                                        .notifier,
                                                  )
                                                  .setBackgroundId(def.id);
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        l10n.profileAvatarFrameSection,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ChoiceChip(
                                          label: Text(
                                            l10n.profileCosmeticDefault,
                                          ),
                                          selected: effectiveFrame == null,
                                          onSelected: (_) async {
                                            await ref
                                                .read(
                                                  profileAvatarFrameIdProvider
                                                      .notifier,
                                                )
                                                .setFrameId(null);
                                          },
                                        ),
                                        for (final def in ownedFrames)
                                          ChoiceChip(
                                            label: Text(
                                              shopItemStrings(
                                                l10n,
                                                def.id,
                                              ).title,
                                            ),
                                            selected:
                                                effectiveFrame == def.id,
                                            onSelected: (_) async {
                                              await ref
                                                  .read(
                                                    profileAvatarFrameIdProvider
                                                        .notifier,
                                                  )
                                                  .setFrameId(def.id);
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        l10n.profileNameStyleSection,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ChoiceChip(
                                          label: Text(
                                            l10n.profileCosmeticDefault,
                                          ),
                                          selected: effectiveNameStyle == null,
                                          onSelected: (_) async {
                                            await ref
                                                .read(
                                                  profileNameStyleIdProvider
                                                      .notifier,
                                                )
                                                .setNameStyleId(null);
                                          },
                                        ),
                                        for (final def in ownedNameStyles)
                                          ChoiceChip(
                                            label: Text(
                                              shopItemStrings(
                                                l10n,
                                                def.id,
                                              ).title,
                                            ),
                                            selected: effectiveNameStyle ==
                                                def.id,
                                            onSelected: (_) async {
                                              await ref
                                                  .read(
                                                    profileNameStyleIdProvider
                                                        .notifier,
                                                  )
                                                  .setNameStyleId(def.id);
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8,
                                  12,
                                  8,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        l10n.settingsLanguage,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (final mode
                                            in AppLocalePreference.values)
                                          ChoiceChip(
                                            label: Text(
                                              switch (mode) {
                                                AppLocalePreference
                                                      .system =>
                                                  l10n.languageSystem,
                                                AppLocalePreference.en =>
                                                  l10n.languageEnglish,
                                                AppLocalePreference.uk =>
                                                  l10n.languageUkrainian,
                                              },
                                            ),
                                            selected:
                                                ref.watch(
                                                      appLocalePreferenceProvider,
                                                    ) ==
                                                    mode,
                                            onSelected: (_) async {
                                              await ref
                                                  .read(
                                                    appLocalePreferenceProvider
                                                        .notifier,
                                                  )
                                                  .setPreference(mode);
                                              if (context.mounted) {
                                                await syncCloseDayReminderWithLocale(
                                                  ref,
                                                  context,
                                                );
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8,
                                  12,
                                  8,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        l10n.settingsAppearance,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    SegmentedButton<AppThemePreference>(
                                      showSelectedIcon: false,
                                      segments: [
                                        ButtonSegment(
                                          value: AppThemePreference.system,
                                          label: Text(l10n.themeSystem),
                                          icon: const Icon(
                                            Icons.brightness_auto,
                                            size: 18,
                                          ),
                                        ),
                                        ButtonSegment(
                                          value: AppThemePreference.light,
                                          label: Text(l10n.themeLight),
                                          icon: const Icon(
                                            Icons.light_mode_outlined,
                                            size: 18,
                                          ),
                                        ),
                                        ButtonSegment(
                                          value: AppThemePreference.dark,
                                          label: Text(l10n.themeDark),
                                          icon: const Icon(
                                            Icons.dark_mode_outlined,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                      selected: {themePref},
                                      onSelectionChanged: (next) {
                                        ref
                                            .read(
                                              themePreferenceProvider
                                                  .notifier,
                                            )
                                            .setPreference(next.first);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!kIsWeb)
                              Card(
                                child: Column(
                                  children: [
                                    SwitchListTile(
                                      secondary: const Icon(
                                        Icons.notifications_outlined,
                                      ),
                                      title: Text(l10n.notifCloseDayToggle),
                                      subtitle: Text(l10n.notifCloseDaySection),
                                      value: reminder.enabled,
                                      onChanged: (v) async {
                                        await ref
                                            .read(
                                              closeDayReminderProvider
                                                  .notifier,
                                            )
                                            .setEnabled(v);
                                        if (context.mounted) {
                                          await syncCloseDayReminderWithLocale(
                                            ref,
                                            context,
                                          );
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.schedule_outlined,
                                      ),
                                      title: Text(l10n.notifCloseDayTime),
                                      enabled: reminder.enabled,
                                      trailing: Text(
                                        TimeOfDay(
                                          hour: reminder.hour,
                                          minute: reminder.minute,
                                        ).format(context),
                                      ),
                                      onTap: reminder.enabled
                                          ? () async {
                                              final picked =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                  hour: reminder.hour,
                                                  minute: reminder.minute,
                                                ),
                                              );
                                              if (picked != null &&
                                                  context.mounted) {
                                                await ref
                                                    .read(
                                                      closeDayReminderProvider
                                                          .notifier,
                                                    )
                                                    .setTime(
                                                      hour: picked.hour,
                                                      minute: picked.minute,
                                                    );
                                                if (context.mounted) {
                                                  await syncCloseDayReminderWithLocale(
                                                    ref,
                                                    context,
                                                  );
                                                }
                                              }
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.bolt_outlined),
                                title: Text(l10n.totalXpLabel),
                                trailing: Text(
                                  '$xp',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.local_fire_department_outlined,
                                ),
                                title: Text(l10n.streakNow),
                                trailing: Text(
                                  '$streak',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.emoji_events_outlined,
                                ),
                                title: Text(l10n.bestStreakLabel),
                                trailing: Text(
                                  '$best',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.phaseAPlaceholder,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
        },
      ),
    );
  }
}
