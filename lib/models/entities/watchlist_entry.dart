import 'package:objectbox/objectbox.dart';
import 'package:popcorn/enums/watchlist_entry_type.dart';


@Entity()
class WatchlistEntry {
  @Id()
  int id = 0;

  late String title;
  late String type;

  int priority = 3;

  bool isFinished = false;
  bool isRecommendable = false;
  bool isUpcoming = false;
  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;
  DateTime? finishedAt;
  DateTime? estimatedReleaseDate;
}