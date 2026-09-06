import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';

import '../models/folder.dart';
import '../models/note.dart';
import '../models/project.dart' show Project, projectColorPalette;
import '../utils/id_generator.dart';
import 'local_data_store.dart';

/// Holds the in-memory notes/folders/projects for whichever folder is
/// currently selected, and mirrors every change straight to disk via
/// [LocalDataStore]. This is the app's single source of truth for
/// workspace content — screens never read files directly.
class WorkspaceController extends ChangeNotifier {
  WorkspaceController({LocalDataStore? store}) : _store = store ?? LocalDataStore();

  final LocalDataStore _store;

  String? _rootPath;
  bool _loading = false;
  bool get loading => _loading;

  List<Note> _notes = [];
  List<NotoFolder> _folders = [];
  List<Project> _projects = [];

  List<Note> get notes => List.unmodifiable(_notes);
  List<NotoFolder> get folders => List.unmodifiable(_folders);
  List<Project> get projects => List.unmodifiable(_projects);

  /// Call whenever the active storage folder changes (including on
  /// first load) to (re)populate everything from disk.
  Future<void> loadFrom(String rootPath) async {
    _rootPath = rootPath;
    _loading = true;
    notifyListeners();

    _notes = await _store.loadNotes(rootPath);
    _folders = await _store.loadFolders(rootPath);
    _projects = await _store.loadProjects(rootPath);

    _loading = false;
    notifyListeners();
  }

  bool get hasRoot => _rootPath != null;

  // ---------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------

  Note createNote({String? folderId, String? projectId}) {
    final note = Note.blank(id: generateId(), folderId: folderId, projectId: projectId);
    _notes = [note, ..._notes];
    notifyListeners();
    unawaited(_store.saveNote(_rootPath!, note));
    return note;
  }

  Future<void> saveNote(Note note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      _notes = [updated, ..._notes];
    } else {
      _notes = List.of(_notes)..[index] = updated;
    }
    notifyListeners();
    await _store.saveNote(_rootPath!, updated);
  }

  Future<void> deleteNote(String id) async {
    _notes = _notes.where((n) => n.id != id).toList();
    notifyListeners();
    await _store.deleteNote(_rootPath!, id);
  }

  Future<void> toggleFavorite(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    final updated = _notes[index].copyWith(favorite: !_notes[index].favorite);
    _notes = List.of(_notes)..[index] = updated;
    notifyListeners();
    await _store.saveNote(_rootPath!, updated);
  }

  Note? noteById(String id) {
    for (final n in _notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  // ---------------------------------------------------------------
  // Folders
  // ---------------------------------------------------------------

  Future<NotoFolder> createFolder(String name) async {
    final folder = NotoFolder(id: generateId(), name: name, createdAt: DateTime.now());
    _folders = [..._folders, folder];
    notifyListeners();
    await _store.saveFolders(_rootPath!, _folders);
    return folder;
  }

  Future<void> renameFolder(String id, String name) async {
    _folders = _folders.map((f) => f.id == id ? f.copyWith(name: name) : f).toList();
    notifyListeners();
    await _store.saveFolders(_rootPath!, _folders);
  }

  Future<void> deleteFolder(String id) async {
    _folders = _folders.where((f) => f.id != id).toList();
    // Notes that pointed at this folder become unfiled rather than
    // silently disappearing from the notes list.
    _notes = _notes
        .map((n) => n.folderId == id ? n.copyWith(clearFolderId: true) : n)
        .toList();
    notifyListeners();
    await _store.saveFolders(_rootPath!, _folders);
    for (final n in _notes.where((n) => n.folderId == null)) {
      await _store.saveNote(_rootPath!, n);
    }
  }

  int noteCountForFolder(String id) => _notes.where((n) => n.folderId == id).length;

  // ---------------------------------------------------------------
  // Projects
  // ---------------------------------------------------------------

  Future<Project> createProject(String name, {int? colorValue}) async {
    final project = Project(
      id: generateId(),
      name: name,
      colorValue: colorValue ?? projectColorPaletteNext(_projects.length),
      createdAt: DateTime.now(),
    );
    _projects = [..._projects, project];
    notifyListeners();
    await _store.saveProjects(_rootPath!, _projects);
    return project;
  }

  Future<void> renameProject(String id, String name) async {
    _projects = _projects.map((p) => p.id == id ? p.copyWith(name: name) : p).toList();
    notifyListeners();
    await _store.saveProjects(_rootPath!, _projects);
  }

  Future<void> archiveProject(String id, bool archived) async {
    _projects = _projects.map((p) => p.id == id ? p.copyWith(archived: archived) : p).toList();
    notifyListeners();
    await _store.saveProjects(_rootPath!, _projects);
  }

  Future<void> deleteProject(String id) async {
    _projects = _projects.where((p) => p.id != id).toList();
    _notes = _notes
        .map((n) => n.projectId == id ? n.copyWith(clearProjectId: true) : n)
        .toList();
    notifyListeners();
    await _store.saveProjects(_rootPath!, _projects);
    for (final n in _notes.where((n) => n.projectId == null)) {
      await _store.saveNote(_rootPath!, n);
    }
  }

  int noteCountForProject(String id) => _notes.where((n) => n.projectId == id).length;
}

int projectColorPaletteNext(int index) =>
    projectColorPalette[index % projectColorPalette.length];
