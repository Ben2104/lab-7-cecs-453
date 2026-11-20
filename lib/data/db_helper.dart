import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database>? _database;
  Future<Database> get database => _database ??= _initDb();

  Future<Database> _initDb() async => openDatabase(
    join(await getDatabasesPath(), 'notes.db'),
    version: 1,
    onCreate: (db, version) => db.execute(
      'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
    ),
  );

  Future<int> insertNote(Note note) async =>
      (await database).insert('notes', note.toMap());

  Future<List<Note>> getNotes() async =>
      (await (await database).query('notes')).map(Note.fromMap).toList();

  Future<int> updateNote(Note note) async => (await database).update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );

  Future<int> deleteNote(int id) async =>
      (await database).delete('notes', where: 'id = ?', whereArgs: [id]);
}
