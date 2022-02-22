import 'dart:async';
import 'package:bawq_test/data/models/note.dart';
import 'package:bawq_test/data/repositories/notes_repo.dart';
import 'package:bawq_test/data/helpers/sqlite_helper.dart';

class SqliteRepository extends NotesRepository {
  final sqlHelper = SqliteHelper.instance;

  @override
  Future<List<Note>> getAllNotes() {
    return sqlHelper.getAllNotes();
  }

  @override
  Stream<List<Note>> watchAllNotes() {
    return sqlHelper.watchAllNotes();
  }

  @override
  Future<int> addNote(Note note) {
    return sqlHelper.addNote(note);
  }

  Future init() async {
    await sqlHelper.database;
    return Future.value();
  }

  @override
  void close() {
    sqlHelper.close();
  }
}
