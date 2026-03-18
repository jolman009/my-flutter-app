import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

import '../../../../core/utils/date_utils.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';

class HabitsLocalDataSource {
  const HabitsLocalDataSource(this._isar);

  final Isar _isar;

  Future<List<Habit>> getHabits() {
    return _isar.habits.where().sortByUpdatedAtDesc().findAll();
  }

  Future<List<HabitCompletion>> getCompletions() {
    return _isar.habitCompletions.where().sortByCompletedOnDesc().findAll();
  }

  Future<void> saveHabit(Habit habit) {
    return _isar.writeTxn(() => _isar.habits.put(habit));
  }

  Future<void> deleteHabit(String habitId) {
    return _isar.writeTxn(() async {
      final habit = await _isar.habits.filter().idEqualTo(habitId).findFirst();
      if (habit != null) {
        await _isar.habits.delete(habit.isarId);
      }

      final completions =
          await _isar.habitCompletions.filter().habitIdEqualTo(habitId).findAll();
      final ids = completions.map((completion) => completion.isarId).toList();
      if (ids.isNotEmpty) {
        await _isar.habitCompletions.deleteAll(ids);
      }
    });
  }

  Future<void> toggleCompletion(HabitCompletion completion) async {
    final normalizedDay = AppDateUtils.startOfDay(completion.completedOn);
    await _isar.writeTxn(() async {
      final existing = await _isar.habitCompletions
          .filter()
          .habitIdEqualTo(completion.habitId)
          .findAll();

      final sameDay = existing.firstWhereOrNull(
        (entry) => AppDateUtils.isSameDay(entry.completedOn, normalizedDay),
      );

      if (sameDay != null) {
        await _isar.habitCompletions.delete(sameDay.isarId);
      } else {
        await _isar.habitCompletions.put(completion);
      }
    });
  }
}

