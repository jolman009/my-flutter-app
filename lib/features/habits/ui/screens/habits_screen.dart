import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../application/habits_providers.dart';
import '../widgets/habit_list_item.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsControllerProvider);
    final controller = ref.read(habitsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              if (state.isLoading && state.habits.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return AppErrorView(
                  message: state.errorMessage!,
                  onRetry: controller.load,
                );
              }

              if (state.views.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.repeat,
                  title: 'No habits yet',
                  message: 'Create daily or weekly habits and start building streaks.',
                );
              }

              return ListView.separated(
                itemCount: state.views.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final habitData = state.views[index];
                  return HabitListItem(
                    habitData: habitData,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRouter.habitEditor,
                      arguments: habitData.habit,
                    ),
                    onDelete: () async {
                      final confirmed = await showConfirmDeleteDialog(
                        context,
                        title: 'Delete habit?',
                        message: 'This removes the habit and its completion history.',
                      );
                      if (confirmed) {
                        await controller.deleteHabit(habitData.habit.id);
                      }
                    },
                    onToggleDay: (day) => controller.toggleCompletion(
                      habitData.habit,
                      day,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

