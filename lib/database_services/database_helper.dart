import 'package:path_provider/path_provider.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/objectbox.g.dart';

class DatabaseHelper {
  static late Store store;
  static late Box<EntryCategory> entryCategoryBox;
  static late Box<WatchlistEntry> watchlistEntryBox;

  /// Initializes a singleton store for objectBox
  static Future<void> initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    store = await openStore(directory: dir.path);
    entryCategoryBox = store.box<EntryCategory>();
    watchlistEntryBox = store.box<WatchlistEntry>();
  }
}