import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

class WatchlistEntryDatabaseService {
  static late Isar isar;

  static Future<Isar> initializeDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [WatchlistEntrySchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<List<WatchlistEntry>> getUnfinishedEntries() async {
    List<WatchlistEntry> entries =
        await isar.watchlistEntrys
            .filter()
            .isFinishedEqualTo(false)
            .sortByPriority()
            .findAll();

    return entries;
  }

  Future<void> add(WatchlistEntry entity) async {
    entity.createdAt = DateTime.now();
    await isar.writeTxn(() => isar.watchlistEntrys.put(entity));
  }

  // TODO: Update

  // TODO: Delete
}
