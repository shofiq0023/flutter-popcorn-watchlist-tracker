import 'package:isar/isar.dart';

enum WatchlistEntryPriority {
  high(1),
  medium(2),
  normal(3);

  const WatchlistEntryPriority(this.val);

  final short val;
}