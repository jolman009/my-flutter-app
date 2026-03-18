import 'package:isar/isar.dart';

import '../models/note.dart';

class NotesLocalDataSource {
  const NotesLocalDataSource(this._isar);

  final Isar _isar;

  Future<List<Note>> getNotes() {
    return _isar.notes.where().sortByUpdatedAtDesc().findAll();
  }

  Future<void> saveNote(Note note) {
    return _isar.writeTxn(() => _isar.notes.put(note));
  }

  Future<void> deleteNote(String id) {
    return _isar.writeTxn(() async {
      final note = await _isar.notes.filter().idEqualTo(id).findFirst();
      if (note != null) {
        await _isar.notes.delete(note.isarId);
      }
    });
  }
}

