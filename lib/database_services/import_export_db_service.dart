import 'package:popcorn/database_services/database_helper.dart';
import 'package:popcorn/models/entities/import_export_entity.dart';
import 'package:popcorn/objectbox.g.dart';

class ImportExportDbService {
  static late Box<ImportExportEntity> box;

  ImportExportDbService() {
    box = DatabaseHelper.store.box<ImportExportEntity>();
  }

  // Find all
  Future<List<ImportExportEntity>> getAll() async {
    Query<ImportExportEntity> query =
        box
            .query()
            .order(ImportExportEntity_.createdAt, flags: Order.descending)
            .build();
    return query.find();
  }

  // Add new import export entry
  Future<void> add(ImportExportEntity entity) async {
    box.put(entity);
  }

  // Delete import export entry
  Future<void> delete(int entityId) async {
    box.remove(entityId);
  }
}
