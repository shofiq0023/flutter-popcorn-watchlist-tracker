import 'package:popcorn/database_services/database_helper.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/objectbox.g.dart';

class EntryCategoryDatabaseService {
  static late Store store;
  static late Box<EntryCategory> box;

  EntryCategoryDatabaseService() {
    box = DatabaseHelper.store.box<EntryCategory>();
  }

  Future<List<EntryCategory>> getAll() async {
    Query<EntryCategory> query = box.query().order(EntryCategory_.categoryName).build();
    return query.find();
  }

  /// Add a new category
  Future<void> add(EntryCategory entity) async {
    box.put(entity);
  }

  /// Update existing category
  Future<void> update(EntryCategory entity) async {
    entity.updatedAt = DateTime.now();
    box.put(entity);
  }

  /// Delete a category with the given ID
  Future<void> delete(int entityId) async {
    box.remove(entityId);
  }

  /// Delete all categories
  Future<void> deleteAll() async {
    box.removeAll();
  }

  /// Clear database and insert new categories
  Future<void> clearAndInsert(List<EntryCategory> categories) async {
    await deleteAll();
    for (EntryCategory category in categories) {
      await add(category);
    }
  }
}