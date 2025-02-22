import 'package:isar/isar.dart';
import 'package:popcorn/enums/watchlist_entry_type.dart';

part 'watchlist_entry.g.dart';

@Collection()
class WatchlistEntry {
  Id id = Isar.autoIncrement;
  late String title;
  late String type;
  @Enumerated(EnumType.ordinal)
  late WatchlistEntryPriority priority = WatchlistEntryPriority.normal;
  late bool isFinished = false;
  late bool isRecommendable = false;
  late bool isUpcoming = false;
  late DateTime createdAt = DateTime.now();
  late DateTime? updatedAt;
  late DateTime? finishedAt;
  late DateTime? estimatedReleaseDate;
}