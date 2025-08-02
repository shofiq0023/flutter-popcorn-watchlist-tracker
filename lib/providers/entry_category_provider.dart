import 'package:flutter/material.dart';
import 'package:popcorn/database_services/entry_category_db_service.dart';
import 'package:popcorn/models/entities/entry_category.dart';

class EntryCategoryProvider extends ChangeNotifier {
  final pageTitle = "Categories";
  final searchToggleTitle = "Search...";
  final searchTextController = TextEditingController();
  bool _isSearching = false;
  bool _isInSelectionMode = false;
  late EntryCategoryDatabaseService db;

  List<EntryCategory> _entryCategoryList = [];
  Map<int, int> selectedEntries = {};

  EntryCategoryProvider() {
    db = EntryCategoryDatabaseService();
    loadCategoryList();
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

  Future<void> loadCategoryList() async {
    _entryCategoryList = await db.getAll();
    notifyListeners();
  }

  Future<List<EntryCategory>> get categoryList async {
    String searchText = searchTextController.text.toLowerCase();
    _entryCategoryList = await db.getAll();

    List<EntryCategory> filterCategoryList =
        _entryCategoryList
            .where((c) => c.categoryName.toLowerCase().contains(searchText))
            .toList();

    return filterCategoryList;
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

  List<EntryCategory> getEntryCategories() {
    return _entryCategoryList;
  }

  int getCategoriesCount() {
    return _entryCategoryList.length;
  }

  bool get isInSelectionMode => _isInSelectionMode;

  void enableSelectionMode() {
    _isInSelectionMode = true;
    notifyListeners();
  }

  void disableSelectionMode() {
    selectedEntries.clear();
    _isInSelectionMode = false;
    notifyListeners();
  }

  void addToSelectedEntryCategory(EntryCategory entry) {
    int entryId = entry.id;
    selectedEntries.putIfAbsent(entryId, () => entryId);
    notifyListeners();
  }

  void removeFromSelectedEntryCategory(EntryCategory entry) {
    int entryId = entry.id;
    selectedEntries.remove(entryId);

    if (selectedEntries.isEmpty) {
      disableSelectionMode();
    }
    notifyListeners();
  }

  bool isSelectedEntryCategory(EntryCategory entry) {
    int entryId = entry.id;
    return selectedEntries.containsKey(entryId);
  }

  EntryCategory _getEntryById(int id) {
    return _entryCategoryList.firstWhere((e) => e.id == id);
  }

  void deleteSelectedEntryCategories() {
    for (int entryId in selectedEntries.keys) {
      EntryCategory entry = _getEntryById(entryId);
      delete(entry);
    }

    disableSelectionMode();
    notifyListeners();
  }
}
