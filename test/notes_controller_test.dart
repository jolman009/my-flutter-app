import 'package:flutter_test/flutter_test.dart';
import 'package:productivity_hub/core/services/analytics_service.dart';
import 'package:productivity_hub/core/services/uuid_service.dart';
import 'package:productivity_hub/features/notes/application/notes_controller.dart';
import 'package:productivity_hub/features/notes/data/models/note.dart';
import 'package:productivity_hub/features/notes/data/repositories/notes_repository.dart';

class _FakeNotesRepository implements NotesRepository {
  final List<Note> _notes = [];

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
  }

  @override
  Future<List<Note>> getNotes() async => List.unmodifiable(_notes);

  @override
  Future<void> saveNote(Note note) async {
    _notes.removeWhere((entry) => entry.id == note.id);
    _notes.add(note);
  }
}

void main() {
  test('filters notes by tag and search query', () async {
    final repository = _FakeNotesRepository();
    final controller = NotesController(
      repository: repository,
      uuidService: const UuidService(),
      analyticsService: NoopAnalyticsService(),
    );

    await controller.saveNote(
      title: 'Weekly review',
      body: 'Summarize wins',
      tag: 'work',
    );
    await controller.saveNote(
      title: 'Groceries',
      body: 'Milk and bread',
      tag: 'home',
    );

    controller.setSelectedTag('work');
    expect(controller.state.filteredNotes.single.title, 'Weekly review');

    controller.setSelectedTag(null);
    controller.setSearchQuery('bread');
    expect(controller.state.filteredNotes.single.title, 'Groceries');
  });
}

