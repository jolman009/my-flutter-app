import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/isar_config.dart';
import '../../tasks/application/tasks_providers.dart';
import '../data/datasources/notes_local_data_source.dart';
import '../data/repositories/local_notes_repository.dart';
import '../data/repositories/notes_repository.dart';
import 'notes_controller.dart';

final notesLocalDataSourceProvider = Provider<NotesLocalDataSource>(
  (ref) => NotesLocalDataSource(ref.watch(appIsarProvider)),
);

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => LocalNotesRepository(ref.watch(notesLocalDataSourceProvider)),
);

final notesControllerProvider =
    StateNotifierProvider<NotesController, NotesState>((ref) {
  final controller = NotesController(
    repository: ref.watch(notesRepositoryProvider),
    uuidService: ref.watch(uuidServiceProvider),
    analyticsService: ref.watch(analyticsServiceProvider),
  );
  controller.load();
  return controller;
});

