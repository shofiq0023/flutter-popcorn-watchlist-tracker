import 'package:objectbox/objectbox.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

@Entity()
class ImportExportEntity {
  @Id()
  int id = 0;

  late String title;
  late List<EntryCategory> categories;
  late List<WatchlistEntry> watchlistEntries;
  DateTime createdAt = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories.map((category) => category.toJson()).toList(),
      'watchlistEntries': watchlistEntries.map((entry) => entry.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
