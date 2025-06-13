import 'package:popcorn/database_services/database_helper.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/objectbox.g.dart';

class WatchlistEntryDatabaseService {
  static late Box<WatchlistEntry> box;

  WatchlistEntryDatabaseService() {
    box = DatabaseHelper.store.box<WatchlistEntry>();
  }

  // Get unfinished entries (sorted by priority)
  Future<List<WatchlistEntry>> getUnfinishedEntries() async {
    Query<WatchlistEntry> query = box.query(WatchlistEntry_.isFinished.equals(false))
        .order(WatchlistEntry_.priority)
        .build();
    return query.find();
  }

  // Get finished entries (sorted by priority)
  Future<List<WatchlistEntry>> getFinishedEntries() async {
    Query<WatchlistEntry> query = box.query(WatchlistEntry_.isFinished.equals(true))
        .order(WatchlistEntry_.priority)
        .build();
    return query.find();
  }

  // Add new entry
  Future<void> add(WatchlistEntry entity) async {
    entity.createdAt = DateTime.now();
    box.put(entity);
  }

  // Update entry
  Future<void> update(WatchlistEntry entity) async {
    entity.updatedAt = DateTime.now();
    box.put(entity);
  }

  // Mark as finished
  Future<void> finished(WatchlistEntry entity) async {
    entity.updatedAt = DateTime.now();
    entity.isFinished = true;
    entity.finishedAt = DateTime.now();
    box.put(entity);
  }

  // Delete entry
  Future<void> delete(int entityId) async {
    box.remove(entityId);
  }
}