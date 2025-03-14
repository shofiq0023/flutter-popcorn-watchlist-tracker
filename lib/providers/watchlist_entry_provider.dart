import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:popcorn/database_services/watchlist_entry_db_service.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

class WatchlistEntryProvider extends ChangeNotifier {
  final homePageTitle = "Watch list";
  final searchToggleTitle = "Search...";
  final searchTextController = TextEditingController();

  late WatchlistEntryDatabaseService db;
  bool _isSearching = false;

  List<WatchlistEntry> _watchList = [];

  WatchlistEntryProvider() {
    db = WatchlistEntryDatabaseService();
  }

  Widget buildTitle() {
    if (_isSearching) {
      return TextField(
        controller: searchTextController,
        onChanged: (value) => setSearchText(value),
        decoration: InputDecoration(
          hintText: searchToggleTitle,
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
      return Text(homePageTitle);
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

  Future<List<WatchlistEntry>> get watchList async {
    _watchList = await db.getUnfinishedEntries();

    return _watchList;
  }

  Future<void> add(WatchlistEntry entity) async {
    await db.add(entity);
    notifyListeners();
  }

  Future<void> update(WatchlistEntry entity) async {
    await db.update(entity);
    notifyListeners();
  }

  Future<void> finished(WatchlistEntry entity) async {
    await db.finished(entity);
    notifyListeners();
  }
}
