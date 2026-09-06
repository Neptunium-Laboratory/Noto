import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/settings_controller.dart';
import '../../core/services/workspace_controller.dart';
import 'note_editor_screen.dart';
import 'widgets/note_list_view.dart';

/// Shows the notes inside a single project or folder. Used by both the
/// Projects and Folders tabs so "open a project" and "open a folder"
/// feel like the same kind of place — just filtered differently.
class FilteredNotesScreen extends StatelessWidget {
  const FilteredNotesScreen({
    super.key,
    required this.title,
    this.projectId,
    this.folderId,
  }) : assert(projectId != null || folderId != null);

  final String title;
  final String? projectId;
  final String? folderId;

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final sortOrder = context.watch<SettingsController>().settings.sortOrder;

    final notes = workspace.notes.where((n) {
      if (projectId != null) return n.projectId == projectId;
      return n.folderId == folderId;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: NoteListView(
        notes: notes,
        sortOrder: sortOrder,
        emptyIcon: Icons.notes_outlined,
        emptyTitle: 'No notes here yet',
        emptyMessage: 'Notes you add here will show up in this list.',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final note = workspace.createNote(folderId: folderId, projectId: projectId);
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
