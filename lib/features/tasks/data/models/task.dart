import 'package:isar/isar.dart';

import 'task_priority.dart';

part 'task.g.dart';

@collection
class Task {
  Task({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority = TaskPriority.medium,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Id isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  String? description;
  late bool isCompleted;
  DateTime? dueDate;

  @enumerated
  late TaskPriority priority;

  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    bool clearDueDate = false,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Task(
      isarId: isarId,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

