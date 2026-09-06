import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/settings_controller.dart';
import '../../../core/services/workspace_controller.dart';
import '../../notes/widgets/note_list_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final sortOrder = context.watch<SettingsController>().settings.sortOrder;
    final favorites = workspace.notes.where((n) => n.favorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: NoteListView(
        notes: favorites,
        sortOrder: sortOrder,
        emptyIcon: Icons.star_border_rounded,
        emptyTitle: 'No favorites yet',
        emptyMessage: 'Tap the star on any note to pin it here.',
      ),
    );
  }
}
