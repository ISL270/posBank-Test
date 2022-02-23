import 'package:bawq_test/data/repositories/sqlite_repo.dart';
import 'package:bawq_test/data/repositories/api_repo.dart';
import 'package:bawq_test/data/models/note.dart';
import 'package:bawq_test/data/providers/mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/globals.dart';

class AddNoteBottomSheet extends StatefulWidget {
  const AddNoteBottomSheet({Key? key}) : super(key: key);

  @override
  _AddNoteBottomSheetState createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  String? _note;

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);
    final sqlRepo = Provider.of<SqliteRepository>(context);
    final apiRepo = Provider.of<APIrepository>(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (newValue) => _note = newValue,
                onSaved: (newValue) => _note = newValue,
                decoration: const InputDecoration(
                  labelText: "Note",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => onPressed(apiRepo, sqlRepo, modeProvider),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onPressed(APIrepository api, SqliteRepository repository,
      ModeProvider modeProvider) {
    if (_note != null && _note!.isNotEmpty) {
      Note note = Note(_note);
      modeProvider.useSQLite ? repository.addNote(note) : api.addNote(note);
      Navigator.pop(context);
    } else {
      snackbarKey.currentState?.showSnackBar(SnackBar(
        content: const Text("Please enter your note first!"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 255,
            right: 20,
            left: 20),
      ));
    }
  }
}
