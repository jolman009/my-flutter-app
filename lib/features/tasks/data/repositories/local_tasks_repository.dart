import '../datasources/tasks_local_data_source.dart';
import '../models/task.dart';
import 'tasks_repository.dart';

class LocalTasksRepository implements TasksRepository {
  const LocalTasksRepository(this._localDataSource);

  final TasksLocalDataSource _localDataSource;

  @override
  Future<void> deleteTask(String id) => _localDataSource.deleteTask(id);

  @override
  Future<List<Task>> getTasks() => _localDataSource.getTasks();

  @override
  Future<void> saveTask(Task task) => _localDataSource.saveTask(task);
}

