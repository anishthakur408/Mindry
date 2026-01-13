import 'package:hive/hive.dart';

part 'mood.g.dart';

@HiveType(typeId: 1)
enum Mood {
  @HiveField(0)
  terrible,

  @HiveField(1)
  bad,

  @HiveField(2)
  okay,

  @HiveField(3)
  good,

  @HiveField(4)
  amazing;

  String get emoji {
    switch (this) {
      case Mood.terrible:
        return '😢';
      case Mood.bad:
        return '😞';
      case Mood.okay:
        return '😐';
      case Mood.good:
        return '😊';
      case Mood.amazing:
        return '🤩';
    }
  }

  String get displayName {
    switch (this) {
      case Mood.terrible:
        return 'Terrible';
      case Mood.bad:
        return 'Bad';
      case Mood.okay:
        return 'Okay';
      case Mood.good:
        return 'Good';
      case Mood.amazing:
        return 'Amazing';
    }
  }

  int get colorValue {
    switch (this) {
      case Mood.terrible:
        return 0xFFE53935; // Deep Red
      case Mood.bad:
        return 0xFFFF7043; // Orange Red
      case Mood.okay:
        return 0xFFFFA726; // Orange
      case Mood.good:
        return 0xFF66BB6A; // Green
      case Mood.amazing:
        return 0xFF42A5F5; // Blue
    }
  }
}
