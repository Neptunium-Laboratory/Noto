import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/note.dart';
import '../../../core/services/workspace_controller.dart';
import '../../../widgets/empty_state.dart';
import '../note_editor_screen.dart';
import 'note_card.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({
    super.key,
    required this.notes,
    required this.sortOrder,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final List<Note> notes;
  final NoteSortOrder sortOrder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return EmptyState(icon: emptyIcon, title: emptyTitle, message: emptyMessage);
    }

    final sorted = List<Note>.of(notes)..sort(sortOrder.comparator);
    final workspace = context.read<WorkspaceController>();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final note = sorted[index];
        final project = note.projectId == null
            ? null
            : workspace.projects.where((p) => p.id == note.projectId).firstOrNull;
        return NoteCard(
          note: note,
          projectColor: project?.color,
          onToggleFavorite: () => workspace.toggleFavorite(note.id),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NoteEditorScreen(noteId: note.id)),
          ),
        );
      },
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
