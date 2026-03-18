import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/uuid_service.dart';
import '../../../core/utils/date_utils.dart';
import '../data/models/task.dart';
import '../data/models/task_priority.dart';
import '../data/repositories/tasks_repository.dart';

enum TaskStatusFilter {
  all,
  open,
  completed,
}

enum TaskDateFilter {
  any,
  today,
  upcoming,
  overdue,
}

class TasksState {
  const TasksState({
    this.isLoading = false,
    this.tasks = const [],
    this.statusFilter = TaskStatusFilter.all,
    this.dateFilter = TaskDateFilter.any,
    this.priorityFilter,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Task> tasks;
  final TaskStatusFilter statusFilter;
  final TaskDateFilter dateFilter;
  final TaskPriority? priorityFilter;
  final String? errorMessage;

  List<Task> get filteredTasks {
    return tasks.where((task) {
      final matchesStatus = switch (statusFilter) {
        TaskStatusFilter.all => true,
        TaskStatusFilter.open => !task.isCompleted,
        TaskStatusFilter.completed => task.isCompleted,
      };

      final dueDate = task.dueDate;
      final matchesDate = switch (dateFilter) {
        TaskDateFilter.any => true,
        TaskDateFilter.today => dueDate != null && AppDateUtils.isToday(dueDate),
        TaskDateFilter.upcoming =>
          dueDate != null &&
          !AppDateUtils.isOverdue(dueDate) &&
          !AppDateUtils.isToday(dueDate),
        TaskDateFilter.overdue => dueDate != null && AppDateUtils.isOverdue(dueDate),
      };

      final matchesPriority =
          priorityFilter == null || task.priority == priorityFilter;

      return matchesStatus && matchesDate && matchesPriority;
    }).toList();
  }

  TasksState copyWith({
    bool? isLoading,
    List<Task>? tasks,
    TaskStatusFilter? statusFilter,
    TaskDateFilter? dateFilter,
    TaskPriority? priorityFilter,
    bool clearPriorityFilter = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      statusFilter: statusFilter ?? this.statusFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      priorityFilter:
          clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TasksController extends StateNotifier<TasksState> {
  TasksController({
    required TasksRepository repository,
    required UuidService uuidService,
    required AnalyticsService analyticsService,
  })  : _repository = repository,
        _uuidService = uuidService,
        _analytics = analyticsService,
        super(const TasksState());

  final TasksRepository _repository;
  final UuidService _uuidService;
  final AnalyticsService _analytics;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final tasks = await _repository.getTasks();
      state = state.copyWith(isLoading: false, tasks: tasks);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load tasks.',
      );
    }
  }

  Future<void> saveTask({
    Task? existing,
    required String title,
    String? description,
    DateTime? dueDate,
    required TaskPriority priority,
  }) async {
    final now = DateTime.now();
    final task = (existing ?? Task(id: _uuidService.next(), title: title, createdAt: now, updatedAt: now))
        .copyWith(
      title: title,
      description: description?.trim().isEmpty ?? true ? null : description?.trim(),
      dueDate: dueDate,
      clearDueDate: dueDate == null,
      priority: priority,
      updatedAt: now,
      isSynced: false,
    );

    await _repository.saveTask(task);
    await _analytics.logEvent(
      existing == null ? 'task_created' : 'task_updated',
      parameters: {'task_id': task.id, 'priority': task.priority.name},
    );
    await load();
  }

  Future<void> toggleTask(Task task) async {
    await _repository.saveTask(
      task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
        isSynced: false,
      ),
    );
    await _analytics.logEvent(
      'task_toggled',
      parameters: {'task_id': task.id, 'is_completed': !task.isCompleted},
    );
    await load();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await _analytics.logEvent('task_deleted', parameters: {'task_id': id});
    await load();
  }

  void setStatusFilter(TaskStatusFilter filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setDateFilter(TaskDateFilter filter) {
    state = state.copyWith(dateFilter: filter);
  }

  void setPriorityFilter(TaskPriority? filter) {
    state = state.copyWith(
      priorityFilter: filter,
      clearPriorityFilter: filter == null,
    );
  }
}

