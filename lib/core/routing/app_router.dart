import 'package:flutter/material.dart';

import '../../features/habits/data/models/habit.dart';
import '../../features/habits/ui/screens/habit_editor_screen.dart';
import '../../features/notes/data/models/note.dart';
import '../../features/notes/ui/screens/note_editor_screen.dart';
import '../../features/tasks/data/models/task.dart';
import '../../features/tasks/ui/screens/task_editor_screen.dart';
import 'app_shell.dart';

class AppRouter {
  static const shell = '/';
  static const taskEditor = '/tasks/editor';
  static const habitEditor = '/habits/editor';
  static const noteEditor = '/notes/editor';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(),
          settings: settings,
        );
      case taskEditor:
        return MaterialPageRoute<void>(
          builder: (_) => TaskEditorScreen(
            initialTask: settings.arguments as Task?,
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      case habitEditor:
        return MaterialPageRoute<void>(
          builder: (_) => HabitEditorScreen(
            initialHabit: settings.arguments as Habit?,
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      case noteEditor:
        return MaterialPageRoute<void>(
          builder: (_) => NoteEditorScreen(
            initialNote: settings.arguments as Note?,
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(),
          settings: settings,
        );
    }
  }
}

