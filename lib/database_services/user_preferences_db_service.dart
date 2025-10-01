import 'package:objectbox/objectbox.dart';
import 'package:popcorn/database_services/database_helper.dart';
import 'package:popcorn/models/entities/user_preferences.dart';

class UserPreferencesDatabaseService {
  static late Box<UserPreferencesEntity> box;

  UserPreferencesDatabaseService() {
    box = DatabaseHelper.store.box<UserPreferencesEntity>();
  }

  // Find one
  Future<UserPreferencesEntity> get() async {
    UserPreferencesEntity? entity = box.get(1);

    if (entity == null) {
      entity = UserPreferencesEntity()
        ..username = 'User'
        ..createdAt = DateTime.now();

      box.put(entity); // Save default to DB
    }

    return entity;
  }



  // Add new import export entry
  Future<void> add(UserPreferencesEntity entity) async {
    box.put(entity);
  }

  // Delete import export entry
  Future<void> delete(int entityId) async {
    box.remove(entityId);
  }
}