import '../models/habit.dart';
import '../models/habit_completion.dart';

abstract class HabitsRepository {
  Future<List<Habit>> getHabits();
  Future<List<HabitCompletion>> getCompletions();
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String habitId);
  Future<void> toggleCompletion(HabitCompletion completion);
}

