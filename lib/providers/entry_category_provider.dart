import 'package:flutter/foundation.dart';
import 'package:popcorn/database_services/entry_category_db_service.dart';
import 'package:popcorn/models/entities/entry_category.dart';

class EntryCategoryProvider extends ChangeNotifier {
  late EntryCategoryDatabaseService db;

  List<EntryCategory> _entryCategoryList = [];

  EntryCategoryProvider() {
    db = EntryCategoryDatabaseService();
  }

  Future<List<EntryCategory>> get categoryList async {
    _entryCategoryList = await db.getAll();

    return _entryCategoryList;
  }

  Future<void> add(EntryCategory entity) async {
    await db.add(entity);
    notifyListeners();
  }

  Future<void> update(EntryCategory entity) async {
    await db.update(entity);
    notifyListeners();
  }

  Future<void> delete(EntryCategory entity) async {
    await db.delete(entity.id);
    notifyListeners();
  }
}