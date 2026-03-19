import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../application/tasks_providers.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/task_list_item.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksControllerProvider);
    final controller = ref.read(tasksControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TaskFilterBar(
                statusFilter: state.statusFilter,
                dateFilter: state.dateFilter,
                priorityFilter: state.priorityFilter,
                onStatusChanged: controller.setStatusFilter,
                onDateChanged: controller.setDateFilter,
                onPriorityChanged: controller.setPriorityFilter,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.tasks.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.errorMessage != null) {
                      return AppErrorView(
                        message: state.errorMessage!,
                        onRetry: controller.load,
                      );
                    }

                    if (state.filteredTasks.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.check_circle_outline,
                        title: 'No tasks yet',
                        message: 'Create a task, add a due date, or adjust the filters.',
                      );
                    }

                    return ListView.separated(
                      itemCount: state.filteredTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = state.filteredTasks[index];
                        return TaskListItem(
                          task: task,
                          onToggle: () => controller.toggleTask(task),
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRouter.taskEditor,
                            arguments: task,
                          ),
                          onDelete: () async {
                            final confirmed = await showConfirmDeleteDialog(
                              context,
                              title: 'Delete task?',
                              message: 'This task will be removed from local storage.',
                            );
                            if (confirmed) {
                              await controller.deleteTask(task.id);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

