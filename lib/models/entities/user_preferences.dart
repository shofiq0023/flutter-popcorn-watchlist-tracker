import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferencesEntity {
  @Id()
  int id = 0;

  String username = "User";

  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}