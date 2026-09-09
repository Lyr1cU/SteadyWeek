import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Drift native default: [getApplicationDocumentsDirectory] + `$name.sqlite`.
const String kDriftDatabaseBaseName = 'life_balance';

const String kDriftDatabaseFileName = '$kDriftDatabaseBaseName.sqlite';

/// Staging file; swapped into [kDriftDatabaseFileName] on next cold start.
const String kDriftDatabaseRestoreStagingFileName =
    '$kDriftDatabaseBaseName.restore.sqlite';

const String kDbRestorePendingPrefsKey = 'db_restore_on_next_launch_v1';

bool looksLikeSqliteFile(Uint8List bytes) {
  if (bytes.length < 16) return false;
  const header = 'SQLite format 3\u0000';
  for (var i = 0; i < header.length; i++) {
    if (bytes[i] != header.codeUnitAt(i)) return false;
  }
  return true;
}

Future<File> driftDatabaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, kDriftDatabaseFileName));
}

/// Applies a staged restore created by [stageDatabaseRestore]. Safe to call
/// before opening [AppDatabase]; run from `main`.
Future<void> applyPendingDbRestoreIfNeeded(SharedPreferences prefs) async {
  if (kIsWeb) return;
  if (!(prefs.getBool(kDbRestorePendingPrefsKey) ?? false)) return;

  final docs = await getApplicationDocumentsDirectory();
  final mainPath = p.join(docs.path, kDriftDatabaseFileName);
  final stagingPath = p.join(docs.path, kDriftDatabaseRestoreStagingFileName);
  final staging = File(stagingPath);

  Future<void> clearPending() async {
    await prefs.remove(kDbRestorePendingPrefsKey);
  }

  if (!await staging.exists()) {
    await clearPending();
    return;
  }

  try {
    final main = File(mainPath);
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('$mainPath$suffix');
      if (await sidecar.exists()) {
        await sidecar.delete();
      }
    }

    if (await main.exists()) {
      final bakPath = p.join(docs.path, '$kDriftDatabaseFileName.bak');
      final bak = File(bakPath);
      if (await bak.exists()) await bak.delete();
      await main.rename(bakPath);
    }

    await staging.rename(mainPath);

    final bakPath = p.join(docs.path, '$kDriftDatabaseFileName.bak');
    final bak = File(bakPath);
    if (await bak.exists()) await bak.delete();
  } catch (e, st) {
    debugPrint('applyPendingDbRestoreIfNeeded: $e\n$st');
  } finally {
    await clearPending();
    if (await staging.exists()) {
      try {
        await staging.delete();
      } catch (_) {}
    }
  }
}

Future<File> createDatabaseExportCopy(AppDatabase db) async {
  if (kIsWeb) {
    throw UnsupportedError('Database export is only available on native');
  }
  try {
    await db.customStatement('PRAGMA wal_checkpoint(FULL);');
  } catch (e, st) {
    debugPrint('wal_checkpoint: $e\n$st');
  }

  final src = await driftDatabaseFile();
  if (!await src.exists()) {
    throw StateError('Database file not found yet.');
  }

  final temp = await getTemporaryDirectory();
  final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  final out = File(p.join(temp.path, 'life_balance_backup_$stamp.sqlite'));
  await src.copy(out.path);
  return out;
}

Future<void> stageDatabaseRestore(Uint8List bytes) async {
  if (kIsWeb) {
    throw UnsupportedError('Database import is only available on native');
  }
  if (!looksLikeSqliteFile(bytes)) {
    throw FormatException('Not a SQLite database file');
  }

  final docs = await getApplicationDocumentsDirectory();
  final staging = File(
    p.join(docs.path, kDriftDatabaseRestoreStagingFileName),
  );
  await staging.writeAsBytes(bytes, flush: true);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(kDbRestorePendingPrefsKey, true);
}
