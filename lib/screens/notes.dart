import 'package:bawq_test/data/models/note.dart';
import 'package:bawq_test/data/providers/mode_provider.dart';
import 'package:bawq_test/data/repositories/sqlite_repo.dart';
import 'package:bawq_test/data/repositories/api_repo.dart';
import 'package:bawq_test/screens/add_note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);
    final sqlRepo = Provider.of<SqliteRepository>(context);
    final apiRepo = Provider.of<APIrepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            onPressed: () => {Navigator.pushNamed(context, '/settings')},
          ),
          IconButton(
            icon: const Icon(
              Icons.person_add,
            ),
            onPressed: () => {Navigator.pushNamed(context, '/addUser')},
          )
        ],
      ),
      body: modeProvider.useSQLite ? sqlNotes(sqlRepo) : apiNotes(apiRepo),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext bc) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddNoteBottomSheet(),
              );
            }).then((_) => setState(() {})),
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  StreamBuilder<List<Note>> sqlNotes(SqliteRepository repository) {
    return StreamBuilder<List<Note>>(
      stream: repository.watchAllNotes(),
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final notes = snapshot.data ?? [];
          return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1.5,
                  indent: 15,
                  endIndent: 15,
                );
              },
              padding: const EdgeInsets.symmetric(vertical: 15),
              itemCount: notes.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(notes[index].note!),
                    trailing: const Icon(Icons.edit),
                  ));
        } else {
          return Container();
        }
      },
    );
  }

  FutureBuilder apiNotes(APIrepository api) {
    return FutureBuilder(
        future: api.getAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final notes = snapshot.data ?? [];
            return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1.5,
                    indent: 15,
                    endIndent: 15,
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: notes.length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(notes[index].note!),
                      trailing: const Icon(Icons.edit),
                    ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container();
        });
  }
}
