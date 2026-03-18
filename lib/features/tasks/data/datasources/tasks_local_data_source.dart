import 'package:isar/isar.dart';

import '../models/task.dart';

class TasksLocalDataSource {
  const TasksLocalDataSource(this._isar);

  final Isar _isar;

  Future<List<Task>> getTasks() async {
    final tasks = await _isar.tasks.where().sortByUpdatedAtDesc().findAll();
    return tasks;
  }

  Future<void> saveTask(Task task) {
    return _isar.writeTxn(() => _isar.tasks.put(task));
  }

  Future<void> deleteTask(String id) {
    return _isar.writeTxn(() async {
      final existing = await _isar.tasks.filter().idEqualTo(id).findFirst();
      if (existing != null) {
        await _isar.tasks.delete(existing.isarId);
      }
    });
  }
}

