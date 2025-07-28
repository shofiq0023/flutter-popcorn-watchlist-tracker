import 'package:flutter/material.dart';
import 'package:popcorn/database_services/watchlist_entry_db_service.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

class WatchlistEntryProvider extends ChangeNotifier {
  final homePageTitle = "Watch list";
  final searchToggleTitle = "Search...";
  final searchTextController = TextEditingController();

  late WatchlistEntryDatabaseService db;
  bool _isSearching = false;
  bool _isSelectionMode = false;

  List<WatchlistEntry> _watchList = [];
  List<WatchlistEntry> _finishedWatchList = [];
  Map<int, int> selectedEntries = {};

  WatchlistEntryProvider() {
    db = WatchlistEntryDatabaseService();
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
    String searchText = searchTextController.text.toLowerCase();
    _watchList = await db.getUnfinishedEntries();

    _watchList.map((c) => print(c.toString()));

    if (searchText.isEmpty) {
      return _watchList;
    }

    List<WatchlistEntry> filteredWatchList =
        _watchList
            .where((w) => w.title.toLowerCase().contains(searchText))
            .toList();

    return filteredWatchList;
  }

  Future<List<WatchlistEntry>> get finishedWatchList async {
    String searchText = searchTextController.text.toLowerCase();
    _finishedWatchList = await db.getFinishedEntries();

    if (searchText.isEmpty) {
      return _finishedWatchList;
    }

    List<WatchlistEntry> filteredWatchList =
        _finishedWatchList
            .where((w) => w.title.toLowerCase().contains(searchText))
            .toList();
    return filteredWatchList;
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

  Future<void> delete(WatchlistEntry entity) async {
    await db.delete(entity.id);
    notifyListeners();
  }

  int entryCount() {
    return _watchList.length;
  }

  bool get isSelectionMode => _isSelectionMode;

  void enableSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void disableSelectionMode() {
    selectedEntries.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  void addToSelectedEntry(WatchlistEntry entry) {
    int entryId = entry.id;
    selectedEntries.putIfAbsent(entryId, () => entryId);
    notifyListeners();
  }

  void removeFromSelectedEntry(WatchlistEntry entry) {
    int entryId = entry.id;
    selectedEntries.remove(entryId);
    notifyListeners();
  }

  bool isSelectedEntry(WatchlistEntry entry) {
    int entryId = entry.id;
    return selectedEntries.containsKey(entryId);
  }
}
