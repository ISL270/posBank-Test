import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bawq_test/data/models/note.dart';
import 'package:bawq_test/services/notes_api.dart';
import 'package:bawq_test/utils/globals.dart';
import 'package:flutter/material.dart';

class APIrepository {
  final NotesAPI notesAPI;
  APIrepository(this.notesAPI);

  List<Note> parseNotes(List<dynamic> notesList) {
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
        notes = parseNotes(data);
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

  Future addNote(Note note) async {
    try {
      await http.post(notesAPI.addNoteUri(),
          headers: {"Content-Type": "application/json"},
          body: json.encode(note.toJsonAPI()));
    } on SocketException {
      snackbarKey.currentState?.showSnackBar(
          const SnackBar(content: Text("No Internet connection!")));
    } on HttpException {
      snackbarKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Couldn't find the requested data!")));
    }
  }
}
