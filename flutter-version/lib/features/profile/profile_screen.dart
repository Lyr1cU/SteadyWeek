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
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
import 'package:life_balance/ui/pressable_scale.dart';
import 'package:life_balance/features/routine/routine_time_picker.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ChromeCard(
        borderRadius: 22,
        lightElevation: 3,
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}

class _ProfileChoiceChip extends StatelessWidget {
  const _ProfileChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingTypography.accentLavender;
    const saveFg = Color(0xFF1E1B4B);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final tc = OnboardingTypography.textColor(brightness);

    return PressableScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onSelected(!selected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? accent
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFF5F3FA)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFE2DBF5)),
              ),
            ),
            child: Text(
              label,
              style:
                  OnboardingTypography.bodyStyle(
                    selected ? saveFg : tc,
                    alpha: selected ? 1 : (isDark ? 0.8 : 0.85),
                  ).copyWith(
                    fontSize: OnboardingTypography.body - 4,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dev / profile builds only — hidden in release (`flutter build`).
Widget _playtestToolsCard(BuildContext context, WidgetRef ref) {
  if (kReleaseMode) return const SizedBox.shrink();
  final accent = OnboardingTypography.accentLavender;
  final brightness = Theme.of(context).brightness;
  final isDark = brightness == Brightness.dark;
  final tc = OnboardingTypography.textColor(brightness);

  return _GlassCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report_outlined, size: 22, color: accent),
              const SizedBox(width: 8),
              Text(
                'Debug playtest',
                style: OnboardingTypography.titleStyle(tc).copyWith(
                  fontSize: OnboardingTypography.body,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Non-release builds only: add XP, unlock streak shop items, set a test name.',
            style: OnboardingTypography.bodyStyle(
              tc,
              alpha: 0.72,
            ).copyWith(fontSize: OnboardingTypography.body - 6),
          ),
          const SizedBox(height: 16),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PressableScale(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : accent.withValues(alpha: 0.12),
                    foregroundColor: isDark ? Colors.white : tc,
                  ),
                  onPressed: () async {
                    await NotificationService.instance.showDebugTestNow();
                  },
                  child: const Text('Test notification now'),
                ),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PressableScale(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : accent.withValues(alpha: 0.12),
                    foregroundColor: isDark ? Colors.white : tc,
                  ),
                  onPressed: () async {
                    await debugGrantXp(ref.read(appDatabaseProvider), 500);
                  },
                  child: const Text('+500 XP'),
                ),
              ),
              PressableScale(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : accent.withValues(alpha: 0.12),
                    foregroundColor: isDark ? Colors.white : tc,
                  ),
                  onPressed: () async {
                    await debugGrantXp(ref.read(appDatabaseProvider), 5000);
                  },
                  child: const Text('+5000 XP'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          PressableScale(
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : accent.withValues(alpha: 0.12),
                foregroundColor: isDark ? Colors.white : tc,
              ),
              onPressed: () async {
                await debugSetBestStreak(ref.read(appDatabaseProvider), 10);
              },
              child: const Text('Best streak = 10 (Ember frame)'),
            ),
          ),
          const SizedBox(height: 8),
          PressableScale(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: tc,
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : const Color(0xFFE2DBF5),
                ),
              ),
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
                        PressableScale(
                          child: TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                        ),
                        PressableScale(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: const Color(0xFF1E1B4B),
                            ),
                            onPressed: () =>
                                Navigator.pop(ctx, controller.text.trim()),
                            child: const Text('Save'),
                          ),
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
          ),
        ],
      ),
    ),
  );
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(userStatsProvider);
    final accent = OnboardingTypography.accentLavender;
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 80;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tc,
        iconTheme: IconThemeData(color: tc),
        title: Text(
          l10n.navProfile,
          style: OnboardingTypography.titleStyle(tc).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: OnboardingTypography.welcome,
          ),
        ),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('$e', style: TextStyle(color: tc)),
        ),
        data: (stats) {
          return ref
              .watch(ownedShopItemIdsProvider)
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('$e', style: TextStyle(color: tc)),
                ),
                data: (owned) {
                  final reminder = ref.watch(closeDayReminderProvider);
                  final xp = stats?.totalXp ?? 0;
                  final streak = stats?.currentStreak ?? 0;
                  final best = stats?.bestStreak ?? 0;
                  final themePref = ref.watch(themePreferenceProvider);
                  final displayName = ref.watch(userDisplayNameProvider);
                  final effectiveBg = ref.watch(
                    effectiveProfileBackgroundIdProvider,
                  );
                  final effectiveFrame = ref.watch(
                    effectiveProfileAvatarFrameIdProvider,
                  );
                  final effectiveNameStyle = ref.watch(
                    effectiveProfileNameStyleIdProvider,
                  );

                  final ownedProfileBgs = kShopCatalog
                      .where(
                        (e) =>
                            e.category == ShopItemCategory.profileBackground &&
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

                  final headerNameBase = OnboardingTypography.titleStyle(
                    tc,
                  ).copyWith(fontSize: 18, fontWeight: FontWeight.w600);

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: displayName != null && displayName.isNotEmpty
                            ? 218 + topInset
                            : 188 + topInset,
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
                            // Градієнт знизу для плавного переходу
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: topInset),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    profileAvatarFrame(
                                      frameId: effectiveFrame,
                                      child: CircleAvatar(
                                        radius: 42,
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.15),
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
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _GlassCard(
                              child: PressableScale(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Icon(
                                    Icons.cloud_outlined,
                                    color: accent,
                                    size: 28,
                                  ),
                                  title: Text(
                                    l10n.profileOpenAuth,
                                    style: OnboardingTypography.bodyStyle(
                                      tc,
                                      alpha: 1,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    l10n.authSubtitle,
                                    style:
                                        OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 0.72,
                                        ).copyWith(
                                          fontSize:
                                              OnboardingTypography.body - 6,
                                        ),
                                  ),
                                  onTap: () => context.push('/auth'),
                                ),
                              ),
                            ),
                            _GlassCard(
                              child: PressableScale(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Icon(
                                    Icons.smart_toy_outlined,
                                    color: accent,
                                    size: 28,
                                  ),
                                  title: Text(
                                    l10n.assistantScreenTitle,
                                    style: OnboardingTypography.bodyStyle(
                                      tc,
                                      alpha: 1,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    l10n.assistantScreenTileSubtitle,
                                    style:
                                        OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 0.72,
                                        ).copyWith(
                                          fontSize:
                                              OnboardingTypography.body - 6,
                                        ),
                                  ),
                                  onTap: () => context.push('/assistant'),
                                ),
                              ),
                            ),
                            if (!kIsWeb)
                              _GlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    20,
                                    20,
                                    16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.save_alt_outlined,
                                            size: 24,
                                            color: accent,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              l10n.profileDbBackupTitle,
                                              style:
                                                  OnboardingTypography.bodyStyle(
                                                    tc,
                                                    alpha: 1,
                                                  ).copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.profileDbBackupSubtitle,
                                        style:
                                            OnboardingTypography.bodyStyle(
                                              tc,
                                              alpha: 0.72,
                                            ).copyWith(
                                              fontSize:
                                                  OnboardingTypography.body - 6,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      PressableScale(
                                        child: FilledButton.icon(
                                          style: FilledButton.styleFrom(
                                            backgroundColor: accent.withValues(
                                              alpha: 0.15,
                                            ),
                                            foregroundColor: accent,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.ios_share_outlined,
                                            size: 20,
                                          ),
                                          label: Text(
                                            l10n.profileDbBackupExport,
                                          ),
                                          onPressed: () async {
                                            try {
                                              final file =
                                                  await createDatabaseExportCopy(
                                                    ref.read(
                                                      appDatabaseProvider,
                                                    ),
                                                  );
                                              if (!context.mounted) return;
                                              await Share.shareXFiles(
                                                [XFile(file.path)],
                                                subject: l10n
                                                    .profileDbBackupShareSubject,
                                              );
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.profileDbBackupExportError(
                                                        '$e',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      PressableScale(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: tc,
                                            side: BorderSide(
                                              color:
                                                  brightness == Brightness.dark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.3,
                                                    )
                                                  : const Color(0xFFE2DBF5),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.restore_outlined,
                                            size: 20,
                                          ),
                                          label: Text(
                                            l10n.profileDbBackupImport,
                                          ),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                  l10n.profileDbBackupImportConfirmTitle,
                                                ),
                                                content: Text(
                                                  l10n.profileDbBackupImportConfirmBody,
                                                ),
                                                actions: [
                                                  PressableScale(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      child: Text(
                                                        l10n.actionCancel,
                                                      ),
                                                    ),
                                                  ),
                                                  PressableScale(
                                                    child: FilledButton(
                                                      style:
                                                          FilledButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.red
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                            foregroundColor:
                                                                Colors.white,
                                                          ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      child: Text(
                                                        l10n.profileDbBackupRestart,
                                                      ),
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
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.profileDbBackupNotSqlite,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.profileDbBackupExportError(
                                                        '$e',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            _playtestToolsCard(context, ref),
                            _GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        l10n.profileBackgroundSection,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _ProfileChoiceChip(
                                          label: l10n.profileCosmeticDefault,
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
                                          _ProfileChoiceChip(
                                            label: shopItemStrings(
                                              l10n,
                                              def.id,
                                            ).title,
                                            selected: effectiveBg == def.id,
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
                            _GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        l10n.profileAvatarFrameSection,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _ProfileChoiceChip(
                                          label: l10n.profileCosmeticDefault,
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
                                          _ProfileChoiceChip(
                                            label: shopItemStrings(
                                              l10n,
                                              def.id,
                                            ).title,
                                            selected: effectiveFrame == def.id,
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
                            _GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        l10n.profileNameStyleSection,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _ProfileChoiceChip(
                                          label: l10n.profileCosmeticDefault,
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
                                          _ProfileChoiceChip(
                                            label: shopItemStrings(
                                              l10n,
                                              def.id,
                                            ).title,
                                            selected:
                                                effectiveNameStyle == def.id,
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
                            _GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        l10n.settingsLanguage,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (final mode
                                            in AppLocalePreference.values)
                                          _ProfileChoiceChip(
                                            label: switch (mode) {
                                              AppLocalePreference.system =>
                                                l10n.languageSystem,
                                              AppLocalePreference.en =>
                                                l10n.languageEnglish,
                                              AppLocalePreference.uk =>
                                                l10n.languageUkrainian,
                                            },
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
                            _GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        l10n.settingsAppearance,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _ProfileChoiceChip(
                                          label: l10n.themeSystem,
                                          selected:
                                              themePref ==
                                              AppThemePreference.system,
                                          onSelected: (_) => ref
                                              .read(
                                                themePreferenceProvider
                                                    .notifier,
                                              )
                                              .setPreference(
                                                AppThemePreference.system,
                                              ),
                                        ),
                                        _ProfileChoiceChip(
                                          label: l10n.themeLight,
                                          selected:
                                              themePref ==
                                              AppThemePreference.light,
                                          onSelected: (_) => ref
                                              .read(
                                                themePreferenceProvider
                                                    .notifier,
                                              )
                                              .setPreference(
                                                AppThemePreference.light,
                                              ),
                                        ),
                                        _ProfileChoiceChip(
                                          label: l10n.themeDark,
                                          selected:
                                              themePref ==
                                              AppThemePreference.dark,
                                          onSelected: (_) => ref
                                              .read(
                                                themePreferenceProvider
                                                    .notifier,
                                              )
                                              .setPreference(
                                                AppThemePreference.dark,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!kIsWeb)
                              _GlassCard(
                                child: Column(
                                  children: [
                                    SwitchListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ),
                                      secondary: Icon(
                                        Icons.notifications_outlined,
                                        color: accent,
                                        size: 28,
                                      ),
                                      title: Text(
                                        l10n.notifCloseDayToggle,
                                        style: OnboardingTypography.bodyStyle(
                                          tc,
                                          alpha: 1,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        l10n.notifCloseDaySection,
                                        style:
                                            OnboardingTypography.bodyStyle(
                                              tc,
                                              alpha: 0.72,
                                            ).copyWith(
                                              fontSize:
                                                  OnboardingTypography.body - 6,
                                            ),
                                      ),
                                      activeThumbColor: const Color(0xFF1E1B4B),
                                      activeTrackColor: accent,
                                      inactiveThumbColor:
                                          brightness == Brightness.dark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : tc.withValues(alpha: 0.55),
                                      inactiveTrackColor:
                                          brightness == Brightness.dark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : tc.withValues(alpha: 0.12),
                                      value: reminder.enabled,
                                      onChanged: (v) async {
                                        await ref
                                            .read(
                                              closeDayReminderProvider.notifier,
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
                                    Divider(
                                      height: 1,
                                      color: tc.withValues(alpha: 0.12),
                                    ),
                                    PressableScale(
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                        leading: Icon(
                                          Icons.schedule_outlined,
                                          color: reminder.enabled
                                              ? accent
                                              : tc.withValues(alpha: 0.35),
                                          size: 28,
                                        ),
                                        title: Text(
                                          l10n.notifCloseDayTime,
                                          style:
                                              OnboardingTypography.bodyStyle(
                                                tc,
                                                alpha: reminder.enabled
                                                    ? 1
                                                    : 0.4,
                                              ).copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        enabled: reminder.enabled,
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: reminder.enabled
                                                ? accent.withValues(alpha: 0.15)
                                                : (brightness == Brightness.dark
                                                      ? Colors.white.withValues(
                                                          alpha: 0.05,
                                                        )
                                                      : tc.withValues(
                                                          alpha: 0.06,
                                                        )),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: reminder.enabled
                                                  ? accent.withValues(
                                                      alpha: 0.3,
                                                    )
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: Text(
                                            TimeOfDay(
                                              hour: reminder.hour,
                                              minute: reminder.minute,
                                            ).format(context),
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  reminder.enabled
                                                      ? accent
                                                      : tc,
                                                  alpha: reminder.enabled
                                                      ? 1
                                                      : 0.4,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      4,
                                                ),
                                          ),
                                        ),
                                        onTap: reminder.enabled
                                            ? () async {
                                                final picked =
                                                    await showRoutineTimePicker(
                                                      context,
                                                      l10n: l10n,
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
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: _GlassCard(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.bolt_outlined,
                                            color: accent,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '$xp',
                                            style:
                                                OnboardingTypography.titleStyle(
                                                  tc,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.totalXpLabel,
                                            textAlign: TextAlign.center,
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  tc,
                                                  alpha: 0.72,
                                                ).copyWith(
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      6,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _GlassCard(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .local_fire_department_outlined,
                                            color: accent,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '$streak',
                                            style:
                                                OnboardingTypography.titleStyle(
                                                  tc,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.streakNow,
                                            textAlign: TextAlign.center,
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  tc,
                                                  alpha: 0.72,
                                                ).copyWith(
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      6,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _GlassCard(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.emoji_events_outlined,
                                            color: accent,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '$best',
                                            style:
                                                OnboardingTypography.titleStyle(
                                                  tc,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.bestStreakLabel,
                                            textAlign: TextAlign.center,
                                            style:
                                                OnboardingTypography.bodyStyle(
                                                  tc,
                                                  alpha: 0.72,
                                                ).copyWith(
                                                  fontSize:
                                                      OnboardingTypography
                                                          .body -
                                                      6,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.phaseAPlaceholder,
                              textAlign: TextAlign.center,
                              style:
                                  OnboardingTypography.bodyStyle(
                                    tc,
                                    alpha: 0.45,
                                  ).copyWith(
                                    fontSize: OnboardingTypography.body - 6,
                                  ),
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
