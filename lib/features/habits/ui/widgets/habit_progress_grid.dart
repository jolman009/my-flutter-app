import 'package:flutter/material.dart';

import '../../application/habits_controller.dart';

class HabitProgressGrid extends StatelessWidget {
  const HabitProgressGrid({
    super.key,
    required this.habit,
    required this.days,
    required this.onToggleDay,
  });

  final HabitViewData habit;
  final List<DateTime> days;
  final ValueChanged<DateTime> onToggleDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: days.map((day) {
        final completed = habit.isCompleteFor(day);
        return InkWell(
          onTap: () => onToggleDay(day),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 38,
            height: 52,
            decoration: BoxDecoration(
              color: completed
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['M', 'T', 'W', 'T', 'F', 'S', 'S'][day.weekday - 1],
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(height: 2),
                Text('${day.day}', style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Icon(
                  completed ? Icons.check : Icons.circle_outlined,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

