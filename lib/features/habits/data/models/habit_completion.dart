import 'package:isar/isar.dart';

part 'habit_completion.g.dart';

@collection
class HabitCompletion {
  HabitCompletion({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.habitId,
    required this.completedOn,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Id isarId;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String habitId;

  @Index()
  late DateTime completedOn;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;
}

