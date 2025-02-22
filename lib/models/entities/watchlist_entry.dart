
import 'package:isar/isar.dart';

part 'watchlist_entry.g.dart';

@Collection()
class WatchListEntry {
  Id id = Isar.autoIncrement;
  late String title;
  late String type;
  late int priority;
  late bool isFinished;
  late bool isRecommendable;
  late bool isUpcoming;
  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime finishedAt;
  late DateTime estimatedReleaseDate;
}