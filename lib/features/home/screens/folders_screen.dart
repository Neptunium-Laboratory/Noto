import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/folder.dart';
import '../../../core/services/workspace_controller.dart';
import '../../../widgets/empty_state.dart';
import '../../notes/filtered_notes_screen.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final folders = List<NotoFolder>.of(workspace.folders)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      body: folders.isEmpty
          ? EmptyState(
              icon: Icons.folder_outlined,
              title: 'No folders yet',
              message: 'Use folders to keep related notes together.',
              actionLabel: 'New folder',
              onAction: () => _createFolder(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: folders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final folder = folders[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(folder.name),
                    subtitle: Text('${workspace.noteCountForFolder(folder.id)} notes'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMenu(context, value, folder),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FilteredNotesScreen(title: folder.name, folderId: folder.id),
                    )),
                  ),
                );
              },
            ),
      floatingActionButton: folders.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _createFolder(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New folder'),
            ),
    );
  }

  Future<void> _handleMenu(BuildContext context, String action, NotoFolder folder) async {
    final workspace = context.read<WorkspaceController>();
    if (action == 'rename') {
      final name = await _promptName(context, initial: folder.name, title: 'Rename folder');
      if (name != null && name.trim().isNotEmpty) {
        await workspace.renameFolder(folder.id, name.trim());
      }
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete this folder?'),
          content: const Text('Notes inside it will stay, but become unfiled.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
          ],
        ),
      );
      if (confirmed == true) {
        await workspace.deleteFolder(folder.id);
      }
    }
  }

  Future<void> _createFolder(BuildContext context) async {
    final name = await _promptName(context, title: 'New folder');
    if (name != null && name.trim().isNotEmpty) {
      await context.read<WorkspaceController>().createFolder(name.trim());
    }
  }

  Future<String?> _promptName(BuildContext context, {String initial = '', required String title}) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Folder name'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Save')),
        ],
      ),
    );
  }
}
