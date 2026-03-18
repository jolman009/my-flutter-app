import 'package:isar/isar.dart';

import 'habit_frequency.dart';

part 'habit.g.dart';

@collection
class Habit {
  Habit({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.name,
    this.description,
    this.frequency = HabitFrequency.daily,
    this.targetDaysOfWeek = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Id isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  String? description;

  @enumerated
  late HabitFrequency frequency;

  late List<int> targetDaysOfWeek;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;

  Habit copyWith({
    String? name,
    String? description,
    HabitFrequency? frequency,
    List<int>? targetDaysOfWeek,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Habit(
      isarId: isarId,
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      targetDaysOfWeek: targetDaysOfWeek ?? this.targetDaysOfWeek,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

