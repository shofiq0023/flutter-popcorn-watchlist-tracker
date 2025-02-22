import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

class WatchlistEntryDatabaseService {
  static late Isar db;

  static Future<Isar> initializeDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      db = await Isar.open(
        [WatchListEntrySchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
