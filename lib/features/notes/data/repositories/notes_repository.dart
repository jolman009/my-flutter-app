import '../models/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<void> saveNote(Note note);
  Future<void> deleteNote(String id);
}

