import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bawq_test/data/models/note.dart';
import 'package:bawq_test/services/notes_api.dart';
import 'package:bawq_test/utils/globals.dart';
import 'package:flutter/material.dart';

class APIhelper {
  final NotesAPI notesAPI;
  APIhelper(this.notesAPI);

  List<Note> parseRecipes(List<dynamic> notesList) {
    final notes = <Note>[];
    notesList.forEach((noteMap) {
      final note = Note.fromJson(noteMap);
      notes.add(note);
    });
    return notes;
  }

  Future<List<Note>> getAllNotes() async {
    List<Note> notes = [];
    try {
      final response = await http.get(notesAPI.getAllNotesUri());
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        notes = parseRecipes(data);
      } else {
        snackbarKey.currentState?.showSnackBar(
            const SnackBar(content: Text("There is no data to display.")));
      }
    } on SocketException {
      snackbarKey.currentState?.showSnackBar(
          const SnackBar(content: Text("No Internet connection!")));
    } on HttpException {
      snackbarKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Couldn't find the requested data!")));
    } on FormatException {
      snackbarKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("Bad response format!")));
    }
    return notes;
  }

  // Stream<List<Note>> watchAllNotes() async* {
  //   final db = await instance.streamDatabase;
  //   yield* db.createQuery(notesTable).mapToList((row) => Note.fromJson(row));
  // }

  // Future<int> addNote(Note note) async {
  //   final db = await instance.streamDatabase;
  //   return db.insert(notesTable, note.toJson());
  // }
}
