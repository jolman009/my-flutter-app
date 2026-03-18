import 'package:flutter_test/flutter_test.dart';
import 'package:productivity_hub/core/services/analytics_service.dart';
import 'package:productivity_hub/core/services/uuid_service.dart';
import 'package:productivity_hub/features/habits/application/habits_controller.dart';
import 'package:productivity_hub/features/habits/data/models/habit.dart';
import 'package:productivity_hub/features/habits/data/models/habit_completion.dart';
import 'package:productivity_hub/features/habits/data/models/habit_frequency.dart';
import 'package:productivity_hub/features/habits/data/repositories/habits_repository.dart';

class _FakeHabitsRepository implements HabitsRepository {
  final List<Habit> _habits = [];
  final List<HabitCompletion> _completions = [];

  @override
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((habit) => habit.id == habitId);
    _completions.removeWhere((completion) => completion.habitId == habitId);
  }

  @override
  Future<List<HabitCompletion>> getCompletions() async => List.unmodifiable(_completions);

  @override
  Future<List<Habit>> getHabits() async => List.unmodifiable(_habits);

  @override
  Future<void> saveHabit(Habit habit) async {
    _habits.removeWhere((item) => item.id == habit.id);
    _habits.add(habit);
  }

  @override
  Future<void> toggleCompletion(HabitCompletion completion) async {
    final existingIndex = _completions.indexWhere(
      (entry) =>
          entry.habitId == completion.habitId &&
          entry.completedOn == completion.completedOn,
    );

    if (existingIndex >= 0) {
      _completions.removeAt(existingIndex);
    } else {
      _completions.add(completion);
    }
  }
}

void main() {
  test('creates habit and toggles completion', () async {
    final repository = _FakeHabitsRepository();
    final controller = HabitsController(
      repository: repository,
      uuidService: const UuidService(),
      analyticsService: NoopAnalyticsService(),
    );

    await controller.saveHabit(
      name: 'Read',
      description: '20 minutes',
      frequency: HabitFrequency.daily,
      targetDaysOfWeek: const [],
    );

    final habit = controller.state.habits.single;
    await controller.toggleCompletion(habit, DateTime.now());

    expect(controller.state.views.single.completions.length, 1);
  });
}

