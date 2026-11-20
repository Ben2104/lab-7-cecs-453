import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_note_saver/data/db_helper.dart';
import 'package:sqflite_note_saver/data/note_model.dart';

void main() {
  test('updated note survives closing and reopening SQLite', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final directory = await Directory.systemTemp.createTemp('notes_test_');
    await databaseFactory.setDatabasesPath(directory.path);
    final helper = DBHelper();
    final id = await helper.insertNote(
      Note(title: 'Before', description: 'Before'),
    );
    await helper.insertNote(Note(title: 'Other', description: 'Untouched'));
    await helper.updateNote(
      Note(id: id, title: 'After', description: 'Updated'),
    );
    await (await helper.database).close();
    final reopened = await databaseFactory.openDatabase(
      path.join(directory.path, 'notes.db'),
    );
    final rows = await reopened.query('notes', orderBy: 'id');
    expect(rows.length, 2);
    expect(rows.first['id'], id);
    expect(rows.first['title'], 'After');
    expect(rows.first['description'], 'Updated');
    expect(rows.last['title'], 'Other');
    await reopened.close();
    await directory.delete(recursive: true);
  });
}
