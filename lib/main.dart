import 'package:bawq_test/screens/add_user.dart';
import 'package:bawq_test/screens/notes.dart';
import 'package:bawq_test/screens/settings.dart';
import 'package:bawq_test/utils/constants.dart';
import 'package:bawq_test/utils/globals.dart';
import 'package:bawq_test/data/repositories/sqlite_repo.dart';
import 'package:bawq_test/data/repositories/api_repo.dart';
import 'package:bawq_test/services/notes_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/providers/mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiRepo = APIrepository(NotesAPI());
  final sqlRepo = SqliteRepository.instance;
  await sqlRepo.database;

  runApp(MyApp(
    sqlRepo: sqlRepo,
    apiRepo: apiRepo,
  ));
}

class MyApp extends StatelessWidget {
  final SqliteRepository sqlRepo;
  final APIrepository apiRepo;
  const MyApp({Key? key, required this.sqlRepo, required this.apiRepo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SqliteRepository>(
          lazy: false,
          create: (_) => sqlRepo,
          dispose: (_, SqliteRepository sqlRepo) => sqlRepo.close(),
        ),
        Provider<APIrepository>(
          lazy: false,
          create: (_) => apiRepo,
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
