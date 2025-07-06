import 'package:permission_handler/permission_handler.dart';

// Request storage permission
Future<bool> requestStoragePermission() async {
  // For Android 10+ (API 29+)
  if (await Permission.storage.request().isGranted) {
    return true;
  }

  // For Android 11+ (API 30+)
  if (await Permission.manageExternalStorage.request().isGranted) {
    return true;
  }

  return false;
}