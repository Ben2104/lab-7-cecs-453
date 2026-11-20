import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import 'add_note_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notes')),
    body: Consumer<NoteProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.notes.isEmpty) {
          return const Center(child: Text('No notes yet. Tap + to add one!'));
        }
        return ListView.builder(
          itemCount: provider.notes.length,
          itemBuilder: (context, index) {
            final note = provider.notes[index];
            return Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit note',
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen(note: note),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete note',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          context.read<NoteProvider>().deleteNote(note.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Add note',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddNoteScreen()),
      ),
      child: const Icon(Icons.add),
    ),
  );
}
