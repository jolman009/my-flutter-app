import '../datasources/notes_local_data_source.dart';
import '../models/note.dart';
import 'notes_repository.dart';

class LocalNotesRepository implements NotesRepository {
  const LocalNotesRepository(this._localDataSource);

  final NotesLocalDataSource _localDataSource;

  @override
  Future<void> deleteNote(String id) => _localDataSource.deleteNote(id);

  @override
  Future<List<Note>> getNotes() => _localDataSource.getNotes();

  @override
  Future<void> saveNote(Note note) => _localDataSource.saveNote(note);
}

