import 'package:bawq_test/screens/add_user.dart';
import 'package:bawq_test/screens/notes.dart';
import 'package:bawq_test/screens/settings.dart';
import 'package:bawq_test/utils/constants.dart';
import 'package:bawq_test/utils/globals.dart';
import 'package:bawq_test/data/repositories/sqlite_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/providers/mode_provider.dart';
import 'data/repositories/notes_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sqlrepository = SqliteRepository();
  await sqlrepository.init();

  runApp(MyApp(repository: sqlrepository));
}

class MyApp extends StatelessWidget {
  final NotesRepository repository;
  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NotesRepository>(
          lazy: false,
          create: (_) => repository,
          dispose: (_, NotesRepository repository) => repository.close(),
        ),
        ChangeNotifierProvider(create: (context) => ModeProvider())
      ],
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        title: 'Bawq Test',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: inputDecorationTheme()),
        routes: {
          '/notes': (context) => const Notes(),
          '/addUser': (context) => const AddUser(),
          '/settings': (context) => const Settings(),
        },
        initialRoute: '/notes',
      ),
    );
  }
}
