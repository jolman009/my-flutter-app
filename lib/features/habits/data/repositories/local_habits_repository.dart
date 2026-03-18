import '../datasources/habits_local_data_source.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';
import 'habits_repository.dart';

class LocalHabitsRepository implements HabitsRepository {
  const LocalHabitsRepository(this._localDataSource);

  final HabitsLocalDataSource _localDataSource;

  @override
  Future<void> deleteHabit(String habitId) => _localDataSource.deleteHabit(habitId);

  @override
  Future<List<HabitCompletion>> getCompletions() =>
      _localDataSource.getCompletions();

  @override
  Future<List<Habit>> getHabits() => _localDataSource.getHabits();

  @override
  Future<void> saveHabit(Habit habit) => _localDataSource.saveHabit(habit);

  @override
  Future<void> toggleCompletion(HabitCompletion completion) =>
      _localDataSource.toggleCompletion(completion);
}

