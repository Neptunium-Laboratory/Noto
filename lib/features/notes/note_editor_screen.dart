import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/note.dart';
import '../../core/services/settings_controller.dart';
import '../../core/services/workspace_controller.dart';

/// Editing surface for a single note.
///
/// Formatting is intentionally lightweight: Noto stores note bodies as
/// plain, portable text, and this screen's toolbar inserts simple
/// Markdown-style tokens (##, **, *, -, [ ]) rather than a binary rich
/// text format. That keeps every note file readable outside of Noto —
/// in line with "local ownership" — while still covering headings,
/// bold, italic, lists, checklists, and links from the MVP feature list.
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, required this.noteId});

  final String noteId;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final FocusNode _bodyFocus = FocusNode();
  Timer? _debounce;
  bool _dirty = false;
  late final WorkspaceController _workspace;
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _workspace = context.read<WorkspaceController>();
    _settingsController = context.read<SettingsController>();
    final note = _workspace.noteById(widget.noteId);
    _titleController = TextEditingController(text: note?.title ?? '');
    _bodyController = TextEditingController(text: note?.body ?? '');
    _titleController.addListener(_onChanged);
    _bodyController.addListener(_onChanged);
  }

  void _onChanged() {
    _dirty = true;
    final autosave = _settingsController.settings.autosaveEnabled;
    if (!autosave) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _save);
  }

  Future<void> _save() async {
    if (!_dirty) return;
    final existing = _workspace.noteById(widget.noteId);
    if (existing == null) return;
    await _workspace.saveNote(existing.copyWith(
      title: _titleController.text,
      body: _bodyController.text,
    ));
    _dirty = false;
  }

  void _insertAtSelection(String prefix, {String suffix = ''}) {
    final selection = _bodyController.selection;
    final text = _bodyController.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final selected = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selected$suffix');
    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + prefix.length + selected.length),
    );
    _bodyFocus.requestFocus();
  }

  void _insertLinePrefix(String prefix) {
    final text = _bodyController.text;
    final offset = _bodyController.selection.baseOffset < 0 ? text.length : _bodyController.selection.baseOffset;
    final lineStart = text.lastIndexOf('\n', (offset - 1).clamp(0, text.length)) + 1;
    final newText = text.replaceRange(lineStart, lineStart, prefix);
    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset + prefix.length),
    );
    _bodyFocus.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (_dirty) {
      // Best-effort final save; fire-and-forget since the widget is
      // going away. Uses the cached controller reference, not context,
      // since context lookups aren't safe once dispose() has started.
      final existing = _workspace.noteById(widget.noteId);
      if (existing != null) {
        _workspace.saveNote(existing.copyWith(
          title: _titleController.text,
          body: _bodyController.text,
        ));
      }
    }
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspace = context.watch<WorkspaceController>();
    final note = workspace.noteById(widget.noteId);

    if (note == null) {
      // The note was deleted elsewhere (e.g. folder cleanup) while this
      // screen was open.
      return const Scaffold(body: Center(child: Text('This note is gone.')));
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) => _save(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(note.favorite ? Icons.star_rounded : Icons.star_border_rounded),
              tooltip: note.favorite ? 'Remove from favorites' : 'Add to favorites',
              onPressed: () => workspace.toggleFavorite(note.id),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Delete note',
              onPressed: () => _confirmDelete(context, workspace),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: theme.textTheme.headlineSmall,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      focusNode: _bodyFocus,
                      style: theme.textTheme.bodyLarge,
                      maxLines: null,
                      minLines: 10,
                      decoration: const InputDecoration(
                        hintText: 'Start writing…',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _FormattingToolbar(
              onHeading: () => _insertLinePrefix('## '),
              onBold: () => _insertAtSelection('**', suffix: '**'),
              onItalic: () => _insertAtSelection('*', suffix: '*'),
              onList: () => _insertLinePrefix('- '),
              onChecklist: () => _insertLinePrefix('[ ] '),
              onLink: () => _insertAtSelection('[', suffix: '](url)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WorkspaceController workspace) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this note?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      _dirty = false;
      await workspace.deleteNote(widget.noteId);
      if (mounted) Navigator.of(context).pop();
    }
  }
}

class _FormattingToolbar extends StatelessWidget {
  const _FormattingToolbar({
    required this.onHeading,
    required this.onBold,
    required this.onItalic,
    required this.onList,
    required this.onChecklist,
    required this.onLink,
  });

  final VoidCallback onHeading;
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onList;
  final VoidCallback onChecklist;
  final VoidCallback onLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.title_rounded), tooltip: 'Heading', onPressed: onHeading),
              IconButton(icon: const Icon(Icons.format_bold_rounded), tooltip: 'Bold', onPressed: onBold),
              IconButton(icon: const Icon(Icons.format_italic_rounded), tooltip: 'Italic', onPressed: onItalic),
              IconButton(icon: const Icon(Icons.format_list_bulleted_rounded), tooltip: 'List', onPressed: onList),
              IconButton(icon: const Icon(Icons.checklist_rounded), tooltip: 'Checklist', onPressed: onChecklist),
              IconButton(icon: const Icon(Icons.link_rounded), tooltip: 'Link', onPressed: onLink),
            ],
          ),
        ),
      ),
    );
  }
}
