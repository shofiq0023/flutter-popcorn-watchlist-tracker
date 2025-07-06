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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.target?.toJson(),
      'priority': priority,
      'isFinished': isFinished,
      'isRecommendable': isRecommendable,
      'isUpcoming': isUpcoming,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'estimatedReleaseDate': estimatedReleaseDate?.toIso8601String(),
    };
  }
}