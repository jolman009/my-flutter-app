import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../application/habits_providers.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_frequency.dart';

class HabitEditorScreen extends ConsumerStatefulWidget {
  const HabitEditorScreen({
    super.key,
    this.initialHabit,
  });

  final Habit? initialHabit;

  @override
  ConsumerState<HabitEditorScreen> createState() => _HabitEditorScreenState();
}

class _HabitEditorScreenState extends ConsumerState<HabitEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  HabitFrequency _frequency = HabitFrequency.daily;
  late Set<int> _selectedWeekdays;

  @override
  void initState() {
    super.initState();
    final habit = widget.initialHabit;
    _nameController = TextEditingController(text: habit?.name ?? '');
    _descriptionController = TextEditingController(text: habit?.description ?? '');
    _frequency = habit?.frequency ?? HabitFrequency.daily;
    _selectedWeekdays = {...?habit?.targetDaysOfWeek};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialHabit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Habit' : 'New Habit')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                hintText: 'Optional',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<HabitFrequency>(
                value: _frequency,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _frequency = value);
                  }
                },
                items: HabitFrequency.values
                    .map(
                      (frequency) => DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.name),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              if (_frequency == HabitFrequency.weekly) ...[
                const SizedBox(height: 16),
                Text(
                  'Target days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List<Widget>.generate(7, (index) {
                    final weekday = index + 1;
                    final selected = _selectedWeekdays.contains(weekday);
                    return FilterChip(
                      label: Text(
                        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          if (selected) {
                            _selectedWeekdays.remove(weekday);
                          } else {
                            _selectedWeekdays.add(weekday);
                          }
                        });
                      },
                    );
                  }),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(isEditing ? 'Save Changes' : 'Create Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_frequency == HabitFrequency.weekly && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one target day.')),
      );
      return;
    }

    await ref.read(habitsControllerProvider.notifier).saveHabit(
          existing: widget.initialHabit,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          frequency: _frequency,
          targetDaysOfWeek: _selectedWeekdays.toList()..sort(),
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

