import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../application/notes_providers.dart';
import '../../data/models/note.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({
    super.key,
    this.initialNote,
  });

  final Note? initialNote;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  static const _palette = <int>[
    0xFFFFFFFF,
    0xFFFFF2C6,
    0xFFFFD8CC,
    0xFFDDF4E4,
    0xFFDCEBFF,
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _tagController;
  int? _selectedColor;

  @override
  void initState() {
    super.initState();
    final note = widget.initialNote;
    _titleController = TextEditingController(text: note?.title ?? '');
    _bodyController = TextEditingController(text: note?.body ?? '');
    _tagController = TextEditingController(text: note?.tag ?? '');
    _selectedColor = note?.colorValue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialNote != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'New Note')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _bodyController,
                label: 'Body',
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Body is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _tagController,
                label: 'Tag',
                hintText: 'Optional',
              ),
              const SizedBox(height: 16),
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _palette.map((colorValue) {
                  final selected = _selectedColor == colorValue;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = colorValue),
                    borderRadius: BorderRadius.circular(999),
                    child: CircleAvatar(
                      backgroundColor: Color(colorValue),
                      child: selected
                          ? const Icon(Icons.check, color: Colors.black)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(isEditing ? 'Save Changes' : 'Create Note'),
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

    await ref.read(notesControllerProvider.notifier).saveNote(
          existing: widget.initialNote,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          colorValue: _selectedColor,
          tag: _tagController.text.trim(),
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

