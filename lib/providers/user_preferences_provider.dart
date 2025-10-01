import 'package:flutter/material.dart';
import 'package:popcorn/database_services/user_preferences_db_service.dart';
import 'package:popcorn/models/entities/user_preferences.dart';

class UserPreferencesProvider extends ChangeNotifier {
  late UserPreferencesDatabaseService db;
  UserPreferencesEntity _userPreferences = UserPreferencesEntity();

  UserPreferencesProvider() {
    db = UserPreferencesDatabaseService();
    loadUserPreferences();
  }

  Future<void> loadUserPreferences() async {
    _userPreferences = await db.get();
    notifyListeners();
  }

  Future<String> get username async {
    _userPreferences = await db.get();
    return _userPreferences.username;
  }

  void updateUsername(String username) {
    _userPreferences.username = username;
    db.add(_userPreferences);
  }
}