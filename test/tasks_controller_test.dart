import 'package:flutter_test/flutter_test.dart';
import 'package:productivity_hub/core/services/analytics_service.dart';
import 'package:productivity_hub/core/services/uuid_service.dart';
import 'package:productivity_hub/features/tasks/application/tasks_controller.dart';
import 'package:productivity_hub/features/tasks/data/models/task.dart';
import 'package:productivity_hub/features/tasks/data/models/task_priority.dart';
import 'package:productivity_hub/features/tasks/data/repositories/tasks_repository.dart';

class _FakeTasksRepository implements TasksRepository {
  final List<Task> _store = [];

  @override
  Future<void> deleteTask(String id) async {
    _store.removeWhere((task) => task.id == id);
  }

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_store);

  @override
  Future<void> saveTask(Task task) async {
    _store.removeWhere((item) => item.id == task.id);
    _store.add(task);
  }
}

void main() {
  test('filters tasks by completion and priority', () async {
    final repository = _FakeTasksRepository();
    final controller = TasksController(
      repository: repository,
      uuidService: const UuidService(),
      analyticsService: NoopAnalyticsService(),
    );

    await controller.saveTask(
      title: 'First',
      priority: TaskPriority.high,
    );
    final firstTask = controller.state.tasks.first;
    await controller.toggleTask(firstTask);
    await controller.saveTask(
      title: 'Second',
      priority: TaskPriority.low,
    );

    controller.setStatusFilter(TaskStatusFilter.completed);
    expect(controller.state.filteredTasks.length, 1);

    controller.setStatusFilter(TaskStatusFilter.all);
    controller.setPriorityFilter(TaskPriority.low);
    expect(controller.state.filteredTasks.single.title, 'Second');
  });
}

