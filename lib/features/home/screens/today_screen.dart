import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/settings_controller.dart';
import '../../../core/services/workspace_controller.dart';
import '../../notes/widgets/note_list_view.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspaceController>();
    final sortOrder = context.watch<SettingsController>().settings.sortOrder;
    final todayNotes = workspace.notes
        .where((n) => _isToday(n.updatedAt) || _isToday(n.createdAt))
        .toList();

    return Scaffold(
      body: NoteListView(
        notes: todayNotes,
        sortOrder: sortOrder,
        emptyIcon: Icons.today_rounded,
        emptyTitle: 'Nothing today yet',
        emptyMessage: 'Notes you create or edit today will show up here.',
      ),
    );
  }
}
