import 'package:app_notes/models/note_model.dart';
import 'package:app_notes/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final String databaseName = "note.db";
  final int databaseVersion = 1;

  final String createUserTable = '''
    CREATE TABLE Users (userId INTEGER PRIMARY KEY AUTOINCREMENT,
    userName TEXT UNIQUE NOT NULL,
    userPassword TEXT NOT NULL)
  ''';

  final String createNoteTable = '''
    CREATE TABLE Notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT,
    noteTitle TEXT NOT NULL,
    noteContent TEXT NOT NULL,
    createdAt TEXT DEFAULT CURRENT_TIMESTAMP)
  ''';

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: (db, version) async {
        await db.execute(createUserTable);
        await db.execute(createNoteTable);
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<bool> login(UserModel user) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [user.userName, user.userPassword],
    );
    return result.isNotEmpty;
  }

  Future<int> register(UserModel user) async {
    final Database db = await database;
    return db.insert('Users', user.toMap());
  }

  Future<int> createNote(NoteModel note) async {
    final Database db = await database;
    return db.insert('Notes', note.toMap());
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final result = await db.query('Notes');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> updateNote(String title, String content, int noteId) async {
    final Database db = await database;
    return db.update(
      'Notes',
      {'noteTitle': title, 'noteContent': content},
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }

  Future<int> deleteNote(int id) async {
    final Database db = await database;
    return db.delete('Notes', where: 'noteId = ?', whereArgs: [id]);
  }

  Future<List<NoteModel>> searchNote(String keyword) async {
    final Database db = await database;
    final List<Map<String, Object?>> result = await db.query(
      'Notes',
      where: 'LOWER(noteTitle) LIKE ? OR LOWER(noteContent) LIKE ?',
      whereArgs: ['%${keyword.toLowerCase()}%', '%${keyword.toLowerCase()}%'],
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }
}
