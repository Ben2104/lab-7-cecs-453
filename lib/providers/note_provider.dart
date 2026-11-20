import 'package:flutter/foundation.dart';

import '../data/note_model.dart';
import '../di/service_locator.dart';
import '../repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider({NoteRepository? repository})
    : _repository = repository ?? getIt<NoteRepository>();
  final NoteRepository _repository;
  List<Note> notes = [];
  bool isLoading = false;

  Future<void> fetchNotes() async {
    isLoading = true;
    notifyListeners();
    try {
      notes = await _repository.getNotes();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    await _repository.insertNote(note);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    await fetchNotes();
  }
}
