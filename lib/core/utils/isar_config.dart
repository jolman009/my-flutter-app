import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/habits/data/models/habit.dart';
import '../../features/habits/data/models/habit_completion.dart';
import '../../features/notes/data/models/note.dart';
import '../../features/tasks/data/models/task.dart';

final appIsarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('Isar must be initialized in main.dart'),
);

Future<Isar> openAppIsar() async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.open(
    [
      TaskSchema,
      HabitSchema,
      HabitCompletionSchema,
      NoteSchema,
    ],
    directory: dir.path,
    inspector: false,
  );
}

