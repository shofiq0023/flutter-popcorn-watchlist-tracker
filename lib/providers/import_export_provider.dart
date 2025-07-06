import 'dart:convert';
import 'dart:io';

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

  ImportExportProvider() {
    entryCategoryDBService = EntryCategoryDatabaseService();
    watchlistEntryDBService = WatchlistEntryDatabaseService();
    importExportDBService = ImportExportDbService();
  }

  // Export data
  Future<bool> exportTableToJson() async {
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
      String fileName = '$backupFileName${DateTime.now().millisecondsSinceEpoch}.json';

      if (await _saveToDownloadFolder(jsonString, fileName)) {
        importExportDBService.add(importExportEntity);
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print('Error exporting table');
      return false;
    }
  }

  // Saves the JSON file in the Download folder of the device
  Future<bool> _saveToDownloadFolder(String jsonString, String? fileName) async {
    try {
      Directory? downloadDir = Directory(backupDirectory);
      if (!await downloadDir.exists()) {
        downloadDir = await getExternalStorageDirectory();
      }

      if (downloadDir == null) {
        print('Could not access download directory');
        return false;
      }

      // Create filename if not provided
      fileName ??= '$backupFileName${DateTime.now().millisecondsSinceEpoch}.json';

      // Ensure filename has .json extension
      if (!fileName.endsWith('.json')) {
        fileName += '.json';
      }

      // Create file path
      String filePath = '${downloadDir.path}/$fileName';
      File file = File(filePath);

      // Write JSON string to file
      await file.writeAsString(jsonString);

      print('Data exported successfully to: $filePath');
      return true;

    } catch (e) {
      print('Error saving file: $e');
      return false;
    }
  }

  // Import data
  // TODO: Create a method to import json files for data restore
}