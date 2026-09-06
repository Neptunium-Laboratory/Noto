import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/note.dart';
import '../../../core/services/settings_controller.dart';
import '../../../core/services/workspace_controller.dart';
import '../../notes/widgets/note_list_view.dart';
import '../../../widgets/empty_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final sortOrder = context.watch<SettingsController>().settings.sortOrder;
    final query = _query.trim().toLowerCase();

    final List<Note> results = query.isEmpty
        ? const []
        : workspace.notes
            .where((n) =>
                n.title.toLowerCase().contains(query) || n.body.toLowerCase().contains(query))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search your notes',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(() {
                _controller.clear();
                _query = '';
              }),
            ),
        ],
      ),
      body: query.isEmpty
          ? const EmptyState(
              icon: Icons.search_rounded,
              title: 'Search your notes',
              message: 'Start typing to find a note by its title or content.',
            )
          : NoteListView(
              notes: results,
              sortOrder: sortOrder,
              emptyIcon: Icons.search_off_rounded,
              emptyTitle: 'No matches',
              emptyMessage: 'Try a different word or phrase.',
            ),
    );
  }
}
