import 'package:objectbox/objectbox.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';

@Entity()
class EntryCategory {
  @Id()
  int id = 0;

  late String categoryName;
  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;

  @Backlink('category')
  final watchlistEntries = ToMany<WatchlistEntry>();
}