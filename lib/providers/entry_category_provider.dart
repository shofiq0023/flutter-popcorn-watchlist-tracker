import 'package:flutter/material.dart';
import 'package:popcorn/database_services/entry_category_db_service.dart';
import 'package:popcorn/models/entities/entry_category.dart';

class EntryCategoryProvider extends ChangeNotifier {
  final pageTitle = "Categories";
  final searchToggleTitle = "Search...";
  final searchTextController = TextEditingController();
  bool _isSearching = false;
  late EntryCategoryDatabaseService db;

  List<EntryCategory> _entryCategoryList = [];

  EntryCategoryProvider() {
    db = EntryCategoryDatabaseService();
  }

  /// Build dynamic AppTitle bar
  Widget buildTitle() {
    if (_isSearching) {
      return TextField(
        controller: searchTextController,
        autofocus: true,
        onChanged: (value) => setSearchText(value),
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: searchToggleTitle,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
          suffixIcon:
          searchTextController.text.isEmpty
              ? null
              : IconButton(
            onPressed: () {
              clearSearch();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      );
    } else {
      return Text(pageTitle);
    }
  }

  void clearSearch() {
    searchTextController.clear();
    notifyListeners();
  }

  void setSearchText(String text) {
    searchTextController.text = text;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      setSearchText("");
    }
    notifyListeners();
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