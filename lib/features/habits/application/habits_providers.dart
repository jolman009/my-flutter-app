import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/isar_config.dart';
import '../../tasks/application/tasks_providers.dart';
import '../data/datasources/habits_local_data_source.dart';
import '../data/repositories/habits_repository.dart';
import '../data/repositories/local_habits_repository.dart';
import 'habits_controller.dart';

final habitsLocalDataSourceProvider = Provider<HabitsLocalDataSource>(
  (ref) => HabitsLocalDataSource(ref.watch(appIsarProvider)),
);

final habitsRepositoryProvider = Provider<HabitsRepository>(
  (ref) => LocalHabitsRepository(ref.watch(habitsLocalDataSourceProvider)),
);

final habitsControllerProvider =
    StateNotifierProvider<HabitsController, HabitsState>((ref) {
  final controller = HabitsController(
    repository: ref.watch(habitsRepositoryProvider),
    uuidService: ref.watch(uuidServiceProvider),
    analyticsService: ref.watch(analyticsServiceProvider),
  );
  controller.load();
  return controller;
});

