import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../application/habits_controller.dart';
import '../../data/models/habit_frequency.dart';
import 'habit_progress_grid.dart';

class HabitListItem extends StatelessWidget {
  const HabitListItem({
    super.key,
    required this.habitData,
    required this.onTap,
    required this.onDelete,
    required this.onToggleDay,
  });

  final HabitViewData habitData;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<DateTime> onToggleDay;

  @override
  Widget build(BuildContext context) {
    final recentDays = List<DateTime>.generate(
      7,
      (index) => AppDateUtils.startOfDay(DateTime.now())
          .subtract(Duration(days: 6 - index)),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habitData.habit.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          habitData.habit.frequency == HabitFrequency.daily
                              ? 'Daily habit'
                              : 'Weekly habit',
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${habitData.streakCount} streak'),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
            if ((habitData.habit.description ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(habitData.habit.description!),
            ],
            const SizedBox(height: 12),
            HabitProgressGrid(
              habit: habitData,
              days: recentDays,
              onToggleDay: onToggleDay,
            ),
          ],
        ),
      ),
    );
  }
}

