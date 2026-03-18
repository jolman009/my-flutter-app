import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/uuid_service.dart';
import '../../../core/utils/isar_config.dart';
import '../data/datasources/tasks_local_data_source.dart';
import '../data/repositories/local_tasks_repository.dart';
import '../data/repositories/tasks_repository.dart';
import 'tasks_controller.dart';

final uuidServiceProvider = Provider((ref) => const UuidService());
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => NoopAnalyticsService(),
);

final tasksLocalDataSourceProvider = Provider<TasksLocalDataSource>(
  (ref) => TasksLocalDataSource(ref.watch(appIsarProvider)),
);

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => LocalTasksRepository(ref.watch(tasksLocalDataSourceProvider)),
);

final tasksControllerProvider =
    StateNotifierProvider<TasksController, TasksState>((ref) {
  final controller = TasksController(
    repository: ref.watch(tasksRepositoryProvider),
    uuidService: ref.watch(uuidServiceProvider),
    analyticsService: ref.watch(analyticsServiceProvider),
  );
  controller.load();
  return controller;
});

