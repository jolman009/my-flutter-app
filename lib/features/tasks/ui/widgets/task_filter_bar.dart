import 'package:flutter/material.dart';

import '../../application/tasks_controller.dart';
import '../../data/models/task_priority.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.statusFilter,
    required this.dateFilter,
    required this.priorityFilter,
    required this.onStatusChanged,
    required this.onDateChanged,
    required this.onPriorityChanged,
  });

  final TaskStatusFilter statusFilter;
  final TaskDateFilter dateFilter;
  final TaskPriority? priorityFilter;
  final ValueChanged<TaskStatusFilter> onStatusChanged;
  final ValueChanged<TaskDateFilter> onDateChanged;
  final ValueChanged<TaskPriority?> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          DropdownButton<TaskStatusFilter>(
            value: statusFilter,
            onChanged: (value) => onStatusChanged(value ?? TaskStatusFilter.all),
            items: TaskStatusFilter.values
                .map(
                  (filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter.name),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 12),
          DropdownButton<TaskDateFilter>(
            value: dateFilter,
            onChanged: (value) => onDateChanged(value ?? TaskDateFilter.any),
            items: TaskDateFilter.values
                .map(
                  (filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter.name),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 12),
          DropdownButton<TaskPriority?>(
            value: priorityFilter,
            hint: const Text('priority'),
            onChanged: onPriorityChanged,
            items: [
              const DropdownMenuItem<TaskPriority?>(
                value: null,
                child: Text('any priority'),
              ),
              ...TaskPriority.values.map(
                (priority) => DropdownMenuItem<TaskPriority?>(
                  value: priority,
                  child: Text(priority.name),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

