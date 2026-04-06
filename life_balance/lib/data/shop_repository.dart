import 'package:drift/drift.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/shop_catalog.dart';

enum PurchaseResult {
  success,
  alreadyOwned,
  insufficientXp,
  lockedByStreak,
  unknownItem,
}

class ShopRepository {
  ShopRepository(this._db);

  final AppDatabase _db;

  Stream<Set<String>> watchOwnedItemIds() {
    return _db.select(_db.ownedShopItems).watch().map(
          (rows) => rows.map((e) => e.itemId).toSet(),
        );
  }

  Future<bool> isOwned(String itemId) async {
    final row = await (_db.select(_db.ownedShopItems)
          ..where((t) => t.itemId.equals(itemId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<PurchaseResult> tryPurchase(String itemId) async {
    final def = shopItemById(itemId);
    if (def == null) return PurchaseResult.unknownItem;

    final stats = await (_db.select(_db.userStats)
          ..where((s) => s.id.equals(1)))
        .getSingle();
    if (def.isLocked(userBestStreak: stats.bestStreak)) {
      return PurchaseResult.lockedByStreak;
    }
    final existing = await (_db.select(_db.ownedShopItems)
          ..where((t) => t.itemId.equals(itemId)))
        .getSingleOrNull();
    if (existing != null) return PurchaseResult.alreadyOwned;
    if (stats.totalXp < def.priceXp) return PurchaseResult.insufficientXp;

    await _db.transaction(() async {
      final latest = await (_db.select(_db.userStats)
            ..where((s) => s.id.equals(1)))
          .getSingle();
      if (latest.totalXp < def.priceXp) {
        throw StateError('xp_changed');
      }
      await (_db.update(_db.userStats)..where((s) => s.id.equals(1))).write(
            UserStatsCompanion(
              totalXp: Value(latest.totalXp - def.priceXp),
            ),
          );
      await _db.into(_db.ownedShopItems).insert(
            OwnedShopItemsCompanion.insert(itemId: itemId),
          );
    });

    return PurchaseResult.success;
  }
}
