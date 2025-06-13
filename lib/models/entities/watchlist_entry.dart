import 'package:objectbox/objectbox.dart';

import 'entry_category.dart';


@Entity()
class WatchlistEntry {
  @Id()
  int id = 0;

  late String title;
  final category = ToOne<EntryCategory>();
  int priority = 3;
  bool isFinished = false;
  bool isRecommendable = false;
  bool isUpcoming = false;
  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;
  DateTime? finishedAt;
  DateTime? estimatedReleaseDate;
}