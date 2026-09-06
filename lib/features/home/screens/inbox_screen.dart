import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/settings_controller.dart';
import '../../../core/services/workspace_controller.dart';
import '../../notes/note_editor_screen.dart';
import '../../notes/widgets/note_list_view.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final sortOrder = context.watch<SettingsController>().settings.sortOrder;

    return Scaffold(
      body: NoteListView(
        notes: workspace.notes,
        sortOrder: sortOrder,
        emptyIcon: Icons.notes_rounded,
        emptyTitle: 'No notes yet',
        emptyMessage: 'Tap the button below to capture your first idea.',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final note = workspace.createNote();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NoteEditorScreen(noteId: note.id)),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New note'),
      ),
    );
  }
}
