import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/uuid_service.dart';
import '../../../core/utils/date_utils.dart';
import '../data/models/habit.dart';
import '../data/models/habit_completion.dart';
import '../data/models/habit_frequency.dart';
import '../data/repositories/habits_repository.dart';

class HabitViewData {
  const HabitViewData({
    required this.habit,
    required this.completions,
    required this.streakCount,
  });

  final Habit habit;
  final List<HabitCompletion> completions;
  final int streakCount;

  bool isCompleteFor(DateTime day) {
    return completions.any((entry) => AppDateUtils.isSameDay(entry.completedOn, day));
  }
}

class HabitsState {
  const HabitsState({
    this.isLoading = false,
    this.habits = const [],
    this.completions = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final String? errorMessage;

  List<HabitViewData> get views {
    return habits.map((habit) {
      final completionsForHabit = completions
          .where((completion) => completion.habitId == habit.id)
          .sorted((a, b) => b.completedOn.compareTo(a.completedOn));
      return HabitViewData(
        habit: habit,
        completions: completionsForHabit,
        streakCount: _calculateStreak(habit, completionsForHabit),
      );
    }).toList();
  }

  HabitsState copyWith({
    bool? isLoading,
    List<Habit>? habits,
    List<HabitCompletion>? completions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HabitsState(
      isLoading: isLoading ?? this.isLoading,
      habits: habits ?? this.habits,
      completions: completions ?? this.completions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static int _calculateStreak(Habit habit, List<HabitCompletion> completions) {
    if (completions.isEmpty) {
      return 0;
    }

    final days = completions
        .map((entry) => AppDateUtils.startOfDay(entry.completedOn))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (habit.frequency == HabitFrequency.daily) {
      var streak = 0;
      var cursor = AppDateUtils.startOfDay(DateTime.now());
      for (final day in days) {
        if (AppDateUtils.isSameDay(day, cursor)) {
          streak++;
          cursor = cursor.subtract(const Duration(days: 1));
        } else if (day.isBefore(cursor)) {
          break;
        }
      }
      return streak;
    }

    final weeks = days
        .map((day) => DateTime(day.year, day.month, day.day - (day.weekday - 1)))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    var streak = 0;
    var cursor = DateTime.now();
    var currentWeek = DateTime(
      cursor.year,
      cursor.month,
      cursor.day - (cursor.weekday - 1),
    );

    for (final week in weeks) {
      if (AppDateUtils.isSameDay(week, currentWeek)) {
        streak++;
        currentWeek = currentWeek.subtract(const Duration(days: 7));
      } else if (week.isBefore(currentWeek)) {
        break;
      }
    }
    return streak;
  }
}

class HabitsController extends StateNotifier<HabitsState> {
  HabitsController({
    required HabitsRepository repository,
    required UuidService uuidService,
    required AnalyticsService analyticsService,
  })  : _repository = repository,
        _uuidService = uuidService,
        _analytics = analyticsService,
        super(const HabitsState());

  final HabitsRepository _repository;
  final UuidService _uuidService;
  final AnalyticsService _analytics;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final habits = await _repository.getHabits();
      final completions = await _repository.getCompletions();
      state = state.copyWith(
        isLoading: false,
        habits: habits,
        completions: completions,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load habits.',
      );
    }
  }

  Future<void> saveHabit({
    Habit? existing,
    required String name,
    String? description,
    required HabitFrequency frequency,
    required List<int> targetDaysOfWeek,
  }) async {
    final now = DateTime.now();
    final habit = existing ??
        Habit(
          id: _uuidService.next(),
          name: name,
          createdAt: now,
          updatedAt: now,
        );

    await _repository.saveHabit(
      habit.copyWith(
        name: name,
        description: description?.trim().isEmpty ?? true ? null : description?.trim(),
        frequency: frequency,
        targetDaysOfWeek:
            frequency == HabitFrequency.daily ? const [] : targetDaysOfWeek,
        updatedAt: now,
        isSynced: false,
      ),
    );

    await _analytics.logEvent(
      existing == null ? 'habit_created' : 'habit_updated',
      parameters: {'habit_id': habit.id, 'frequency': frequency.name},
    );
    await load();
  }

  Future<void> toggleCompletion(Habit habit, DateTime day) async {
    final normalizedDay = AppDateUtils.startOfDay(day);
    await _repository.toggleCompletion(
      HabitCompletion(
        id: _uuidService.next(),
        habitId: habit.id,
        completedOn: normalizedDay,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await _analytics.logEvent(
      'habit_completion_toggled',
      parameters: {'habit_id': habit.id, 'day': normalizedDay.toIso8601String()},
    );
    await load();
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
    await _analytics.logEvent(
      'habit_deleted',
      parameters: {'habit_id': habitId},
    );
    await load();
  }
}

