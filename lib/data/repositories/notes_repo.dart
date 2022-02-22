import 'package:bawq_test/data/models/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getAllNotes();

  Stream<List<Note>> watchAllNotes();

  Future<int> addNote(Note note);

  void close();
}
