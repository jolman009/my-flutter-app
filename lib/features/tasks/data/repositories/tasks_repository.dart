import '../models/task.dart';

abstract class TasksRepository {
  Future<List<Task>> getTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String id);
}

