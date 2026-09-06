import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/project.dart';
import '../../../core/services/workspace_controller.dart';
import '../../../widgets/empty_state.dart';
import '../../notes/filtered_notes_screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final projects = workspace.projects.where((p) => !p.archived).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      body: projects.isEmpty
          ? EmptyState(
              icon: Icons.dashboard_customize_outlined,
              title: 'No projects yet',
              message: 'Group related notes together by creating a project.',
              actionLabel: 'New project',
              onAction: () => _createProject(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(backgroundColor: project.color, radius: 10),
                    title: Text(project.name),
                    subtitle: Text('${workspace.noteCountForProject(project.id)} notes'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMenu(context, value, project),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FilteredNotesScreen(title: project.name, projectId: project.id),
                    )),
                  ),
                );
              },
            ),
      floatingActionButton: projects.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _createProject(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New project'),
            ),
    );
  }

  Future<void> _handleMenu(BuildContext context, String action, Project project) async {
    final workspace = context.read<WorkspaceController>();
    if (action == 'rename') {
      final name = await _promptName(context, initial: project.name, title: 'Rename project');
      if (name != null && name.trim().isNotEmpty) {
        await workspace.renameProject(project.id, name.trim());
      }
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete this project?'),
          content: const Text('Notes inside it will stay, but become unassigned.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
          ],
        ),
      );
      if (confirmed == true) {
        await workspace.deleteProject(project.id);
      }
    }
  }

  Future<void> _createProject(BuildContext context) async {
    final name = await _promptName(context, title: 'New project');
    if (name != null && name.trim().isNotEmpty) {
      await context.read<WorkspaceController>().createProject(name.trim());
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
          decoration: const InputDecoration(hintText: 'Project name'),
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
