import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 2)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  TodoPriority priority;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TodoPriority.medium,
  });

  // Toggle completion status
  void toggle() {
    isCompleted = !isCompleted;
  }
}

@HiveType(typeId: 3)
enum TodoPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high;

  String get displayName {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
    }
  }

  String get emoji {
    switch (this) {
      case TodoPriority.low:
        return '🟣';
      case TodoPriority.medium:
        return '🔵';
      case TodoPriority.high:
        return '🔴';
    }
  }
}
