import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:bawq_test/data/models/note.dart';

class SqliteRepository {
  static const _databaseName = 'NotesTest.db';
  static const _databaseVersion = 1;
  static const notesTable = 'Notes';
  static const noteId = 'id';

  static late BriteDatabase _streamDatabase;

  SqliteRepository._privateConstructor();
  static final SqliteRepository instance =
      SqliteRepository._privateConstructor();

  static var lock = Lock();
  static Database? _database;

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $notesTable (
          $noteId INTEGER PRIMARY KEY,
          text TEXT
        )
        ''');
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, _databaseName);

    Sqflite.setDebugModeOn(true);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    await lock.synchronized(() async {
      if (_database == null) {
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Note> parseRecipes(List<Map<String, dynamic>> notesList) {
    final notes = <Note>[];
    notesList.forEach((noteMap) {
      final note = Note.fromJson(noteMap);
      notes.add(note);
    });
    return notes;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.streamDatabase;
    final notesList = await db.query(notesTable);
    final recipes = parseRecipes(notesList);
    return recipes;
  }

  Stream<List<Note>> watchAllNotes() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(notesTable).mapToList((row) => Note.fromJson(row));
  }

  Future<int> addNote(Note note) async {
    final db = await instance.streamDatabase;
    return db.insert(notesTable, note.toJsonSQLite());
  }

  void close() {
    _streamDatabase.close();
  }
}
