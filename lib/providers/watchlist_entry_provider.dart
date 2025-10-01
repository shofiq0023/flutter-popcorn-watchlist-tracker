import 'package:flutter/material.dart';
import 'package:popcorn/database_services/watchlist_entry_db_service.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

class WatchlistEntryProvider extends ChangeNotifier {
  final homePageTitle = "Watch list";
  final searchToggleTitle = "Search...";
  final searchTextController = TextEditingController();

  int _pageIndex = 0;
  late WatchlistEntryDatabaseService db;
  bool _isSearching = false;
  bool _isSelectionMode = false;

  List<WatchlistEntry> _allWatchList = [];
  List<WatchlistEntry> _unfinishedWatchList = [];
  List<WatchlistEntry> _finishedWatchList = [];
  Map<int, int> selectedEntries = {};
  String _currentSortType = 'default';

  Set<String> _selectedFilterOptions = {};

  WatchlistEntryProvider() {
    db = WatchlistEntryDatabaseService();
    loadAllEntry();
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  int get pageIndex {
    return _pageIndex;
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

  Future<void> loadAllEntry() async {
    _allWatchList = await db.getAll();
    _unfinishedWatchList = _allWatchList.where((w) => !w.isFinished).toList();
    _finishedWatchList = _allWatchList.where((w) => w.isFinished).toList();
    notifyListeners();
  }

  String get currentSortType => _currentSortType;

  /// Get watch list
  Future<List<WatchlistEntry>> get watchList async {
    loadAllEntry();
    String searchText = searchTextController.text.toLowerCase();

    // Apply current sorting after loading
    if (_currentSortType != 'default') {
      sortWatchlist(_currentSortType);
    }

    if (searchText.isEmpty) {
      return _unfinishedWatchList;
    }

    List<WatchlistEntry> filteredWatchList =
        _unfinishedWatchList
            .where((w) => w.title.toLowerCase().contains(searchText))
            .toList();

    filteredWatchList = filterWatchList(filteredWatchList);

    return filteredWatchList;
  }

  /// Get finished watch list
  Future<List<WatchlistEntry>> get finishedWatchList async {
    loadAllEntry();
    String searchText = searchTextController.text.toLowerCase();

    // Apply current sorting after loading
    if (_currentSortType != 'default') {
      sortWatchlist(_currentSortType);
    }

    if (searchText.isEmpty) {
      return _finishedWatchList;
    }

    List<WatchlistEntry> filteredWatchList =
        _finishedWatchList
            .where((w) => w.title.toLowerCase().contains(searchText))
            .toList();

    print(">>>>>>>>>>>>>>>>>>>> WHATS UP");

    filteredWatchList = filterWatchList(filteredWatchList);

    return filteredWatchList;
  }

  List<WatchlistEntry> filterWatchList(List<WatchlistEntry> watchList) {
    List<WatchlistEntry> filteredWatchList = watchList;

    if (_selectedFilterOptions.isNotEmpty) {
      if (_selectedFilterOptions.contains("Recommended")) {
        filteredWatchList =
            watchList.where((w) => w.isRecommendable == true).toList();
      }

      filteredWatchList =
          watchList
              .where(
                (w) => _selectedFilterOptions.contains(
              w.category.target!.categoryName,
            ),
          ).toList();
    }

    print(">>>>>>>>>>>>>>>>>>>>>>>> Filtered list");
    return filteredWatchList;
  }

  void addToFilterOption(String filterOption) {
    _selectedFilterOptions.add(filterOption);
    notifyListeners();
  }

  void removeFromFilterOption(String filterOption) {
    _selectedFilterOptions.remove(filterOption);
    notifyListeners();
  }

  bool selectedFilterOptionsContains(String item) {
    return _selectedFilterOptions.contains(item);
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
    return _unfinishedWatchList.length;
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

    if (selectedEntries.isEmpty) {
      disableSelectionMode();
    }
    notifyListeners();
  }

  bool isSelectedEntry(WatchlistEntry entry) {
    int entryId = entry.id;
    return selectedEntries.containsKey(entryId);
  }

  void finishSelectedEntries({recommendable = false}) {
    for (int entryId in selectedEntries.keys) {
      WatchlistEntry entry = _getEntryById(entryId);
      entry.isRecommendable = recommendable;
      finished(entry);
    }

    disableSelectionMode();
    notifyListeners();
  }

  void removeFinishStatusFromSelectedEntries() {
    for (int entryId in selectedEntries.keys) {
      WatchlistEntry entry = _getEntryById(entryId);
      entry.isFinished = false;
      update(entry);
    }

    disableSelectionMode();
    notifyListeners();
  }

  void removeFinishAndRecommendStatusFromSelectedEntries({
    recommendable = false,
  }) {
    for (int entryId in selectedEntries.keys) {
      WatchlistEntry entry = _getEntryById(entryId);
      entry.isFinished = false;
      entry.isRecommendable = recommendable;
      update(entry);
    }

    disableSelectionMode();
    notifyListeners();
  }

  WatchlistEntry _getEntryById(int id) {
    return _allWatchList.firstWhere((e) => e.id == id);
  }

  void deleteSelectedEntries() {
    for (int entryId in selectedEntries.keys) {
      WatchlistEntry entry = _getEntryById(entryId);
      delete(entry);
    }

    disableSelectionMode();
    notifyListeners();
  }

  void sortWatchlist(String sortType) {
    _currentSortType = sortType;

    switch (sortType) {
      case 'title_asc':
        _unfinishedWatchList.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        _finishedWatchList.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;

      case 'title_desc':
        _unfinishedWatchList.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        _finishedWatchList.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;

      case 'date_asc':
        _unfinishedWatchList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _finishedWatchList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;

      case 'date_desc':
        _unfinishedWatchList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _finishedWatchList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case 'priority_desc':
        _unfinishedWatchList.sort((a, b) => b.priority.compareTo(a.priority));
        _finishedWatchList.sort((a, b) => b.priority.compareTo(a.priority));
        break;

      case 'default':
        _unfinishedWatchList.sort((a, b) => a.priority.compareTo(b.priority));
        _finishedWatchList.sort((a, b) => a.priority.compareTo(b.priority));
        break;

      default:
        break;
    }

    notifyListeners();
  }
}
