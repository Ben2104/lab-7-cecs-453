import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_note_saver/data/note_model.dart';
import 'package:sqflite_note_saver/providers/note_provider.dart';
import 'package:sqflite_note_saver/repository/note_repository.dart';
import 'package:sqflite_note_saver/ui/note_list_screen.dart';

class FakeRepository extends NoteRepository {
  List<Note> stored = [
    Note(id: 1, title: 'Old title', description: 'Old description'),
  ];
  @override
  Future<List<Note>> getNotes() async => List.of(stored);
  @override
  Future<int> updateNote(Note note) async {
    stored[stored.indexWhere((item) => item.id == note.id)] = note;
    return 1;
  }
}

void main() {
  testWidgets('edit icon opens prefilled form and saves the existing note', (
    tester,
  ) async {
    final repository = FakeRepository();
    final provider = NoteProvider(repository: repository);
    await provider.fetchNotes();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: NoteListScreen()),
      ),
    );
    await tester.tap(find.byTooltip('Edit note'));
    await tester.pumpAndSettle();
    expect(find.text('Old title'), findsOneWidget);
    expect(find.text('Old description'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'New title');
    await tester.enterText(find.byType(TextFormField).at(1), 'New description');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('New title'), findsOneWidget);
    expect(find.text('New description'), findsOneWidget);
    expect(repository.stored.single.id, 1);
    provider.dispose();
  });
}
