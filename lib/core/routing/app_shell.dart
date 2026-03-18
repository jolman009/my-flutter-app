import 'package:flutter/material.dart';

import '../../features/habits/ui/screens/habits_screen.dart';
import '../../features/notes/ui/screens/notes_screen.dart';
import '../../features/tasks/ui/screens/tasks_screen.dart';
import 'app_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.pages = const [
      TasksScreen(),
      HabitsScreen(),
      NotesScreen(),
    ],
  });

  final List<Widget> pages;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _titles = ['Tasks', 'Habits', 'Notes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined),
            selectedIcon: Icon(Icons.sticky_note_2),
            label: 'Notes',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onCreatePressed(context),
        icon: const Icon(Icons.add),
        label: Text('Add ${_titles[_currentIndex].substring(0, _titles[_currentIndex].length - 1)}'),
      ),
    );
  }

  void _onCreatePressed(BuildContext context) {
    final route = switch (_currentIndex) {
      0 => AppRouter.taskEditor,
      1 => AppRouter.habitEditor,
      _ => AppRouter.noteEditor,
    };

    Navigator.of(context).pushNamed(route);
  }
}
