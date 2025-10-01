import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popcorn/database_services/entry_category_db_service.dart';
import 'package:popcorn/database_services/import_export_db_service.dart';
import 'package:popcorn/database_services/watchlist_entry_db_service.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/models/entities/import_export_entity.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/utils/storage_permission_helper.dart';

class ImportExportProvider extends ChangeNotifier {
  late WatchlistEntryDatabaseService watchlistEntryDBService;
  late EntryCategoryDatabaseService entryCategoryDBService;
  late ImportExportDbService importExportDBService;

  final String backupDirectory = "/storage/emulated/0/Download";
  final String backupFileName = "popcorn_backup_";

  bool isLoading = false;

  ImportExportProvider() {
    entryCategoryDBService = EntryCategoryDatabaseService();
    watchlistEntryDBService = WatchlistEntryDatabaseService();
    importExportDBService = ImportExportDbService();
  }

  // Export data
  Future<bool> exportTableToJson() async {
    toggleLoading();
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) return false;

      List<WatchlistEntry> allEntry = await watchlistEntryDBService.getAll();
      List<EntryCategory> allCategory = await entryCategoryDBService.getAll();

      ImportExportEntity importExportEntity = ImportExportEntity();
      importExportEntity.title = '${backupFileName}manual';
      importExportEntity.categories = allCategory;
      importExportEntity.watchlistEntries = allEntry;

      String jsonString = jsonEncode(importExportEntity);
      String fileName =
          '$backupFileName${DateTime.now().millisecondsSinceEpoch}.json';

      if (await _saveToDownloadFolder(jsonString, fileName)) {
        importExportDBService.add(importExportEntity);
        toggleLoading();
        return true;
      } else {
        toggleLoading();
        return false;
      }
    } catch (e) {
      toggleLoading();
      return false;
    }
  }

  // Saves the JSON file in the Download folder of the device
  Future<bool> _saveToDownloadFolder(
    String jsonString,
    String? fileName,
  ) async {
    toggleLoading();
    try {
      Directory? downloadDir = Directory(backupDirectory);
      if (!await downloadDir.exists()) {
        downloadDir = await getExternalStorageDirectory();
      }

      if (downloadDir == null) {
        toggleLoading();
        return false;
      }

      // Create filename if not provided
      fileName ??=
          '$backupFileName${DateTime.now().millisecondsSinceEpoch}.json';

      // Ensure filename has .json extension
      if (!fileName.endsWith('.json')) {
        fileName += '.json';
      }

      // Create file path
      String filePath = '${downloadDir.path}/$fileName';
      File file = File(filePath);

      // Write JSON string to file
      await file.writeAsString(jsonString);

      toggleLoading();
      return true;
    } catch (e) {
      toggleLoading();
      return false;
    }
  }

  String fileName = "";

  // Import data
  Future<bool> pickAndReadJsonFile() async {
    toggleLoading();
    try {
      // Pick a JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        // Get the file
        File file = File(result.files.single.path!);
        fileName = result.files.single.name;

        // Read the file content
        String fileContent = await file.readAsString();

        // Parse JSON
        Map<String, dynamic> parsedJson = json.decode(fileContent);

        List<EntryCategory> categories = getCategoriesFromJson(parsedJson);
        List<WatchlistEntry> entries = getEntriesFromJson(parsedJson);

        toggleLoading();
        return clearAndRestoreData(categories, entries);
      } else {
        toggleLoading();
        return false;
      }
    } catch (e) {
      toggleLoading();
      return false;
    }
  }

  List<EntryCategory> getCategoriesFromJson(Map<String, dynamic> json) {
    List<EntryCategory> categories = [];

    json['categories'].forEach((item) {
      categories.add(getCategoryFromJson(item));
    });

    return categories;
  }

  EntryCategory getCategoryFromJson(Map<String, dynamic> json) {
    EntryCategory category = EntryCategory();
    category.id = json['id'];
    category.categoryName = json['categoryName'];
    category.createdAt = DateTime.parse(json['createdAt']);
    category.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;
    return category;
  }

  List<WatchlistEntry> getEntriesFromJson(Map<String, dynamic> json) {
    List<WatchlistEntry> watchListEntries = [];

    json['watchlistEntries'].forEach((item) {
      watchListEntries.add(getEntryFromJson(item));
    });

    return watchListEntries;
  }

  WatchlistEntry getEntryFromJson(Map<String, dynamic> item) {
    WatchlistEntry watchlistEntry = WatchlistEntry();
    watchlistEntry.id = item['id'];
    watchlistEntry.title = item['title'];
    watchlistEntry.category.target = getCategoryFromJson(item['category']);
    watchlistEntry.priority = item['priority'];
    watchlistEntry.isFinished = item['isFinished'];
    watchlistEntry.isRecommendable = item['isRecommendable'];
    watchlistEntry.isUpcoming = item['isUpcoming'];
    watchlistEntry.createdAt = DateTime.parse(item['createdAt']);
    watchlistEntry.updatedAt = item['updatedAt'] != null
        ? DateTime.parse(item['updatedAt'])
        : null;
    watchlistEntry.finishedAt = item['finishedAt'] != null
        ? DateTime.parse(item['finishedAt'])
        : null;
    watchlistEntry.estimatedReleaseDate = item['estimatedReleaseDate'] != null
        ? DateTime.parse(item['estimatedReleaseDate'])
        : null;

    return watchlistEntry;
  }

  bool clearAndRestoreData(List<EntryCategory> categories, List<WatchlistEntry> entries) {
    try {
      entryCategoryDBService.clearAndInsert(categories);
      watchlistEntryDBService.clearAndInsert(entries);
      return true;
    } catch (e) {
      return false;
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
