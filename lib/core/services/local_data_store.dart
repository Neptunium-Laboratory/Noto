import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../models/folder.dart';
import '../models/note.dart';
import '../models/project.dart';

/// Reads and writes Noto's data straight to the user's chosen folder.
///
/// Layout on disk, inside the chosen root folder:
///   <root>/<note-id>.json        one plain, readable JSON file per note
///   <root>/.noto/index.json      folders & projects (organizational
///                                 metadata, not itself "a note")
///
/// Keeping notes as individual top-level files means the folder the user
/// picked stays inspectable and portable — exactly what "your notes stay
/// on your phone" should mean in practice, not just in copy.
class LocalDataStore {
  Directory _metaDir(String rootPath) => Directory(p.join(rootPath, '.noto'));

  File _indexFile(String rootPath) =>
      File(p.join(_metaDir(rootPath).path, 'index.json'));

  Future<void> _ensureMetaDir(String rootPath) async {
    final dir = _metaDir(rootPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  // ---------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------

  Future<List<Note>> loadNotes(String rootPath) async {
    final dir = Directory(rootPath);
    if (!await dir.exists()) return const [];

    final notes = <Note>[];
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      if (name.startsWith('.') || p.extension(name) != '.json') continue;

      try {
        final raw = await entity.readAsString();
        final json = jsonDecode(raw) as Map<String, dynamic>;
        if (json.containsKey('title') && json.containsKey('body')) {
          notes.add(Note.fromJson(json));
        }
      } catch (_) {
        // Skip files that aren't valid Noto notes rather than failing
        // the whole list — the folder may contain other user files.
      }
    }
    return notes;
  }

  Future<void> saveNote(String rootPath, Note note) async {
    final dir = Directory(rootPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File(p.join(rootPath, '${note.id}.json'));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(note.toJson()));
  }

  Future<void> deleteNote(String rootPath, String id) async {
    final file = File(p.join(rootPath, '$id.json'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ---------------------------------------------------------------
  // Folders & Projects
  // ---------------------------------------------------------------

  Future<Map<String, dynamic>> _readIndex(String rootPath) async {
    final file = _indexFile(rootPath);
    if (!await file.exists()) {
      return {'folders': [], 'projects': []};
    }
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.putIfAbsent('folders', () => []);
      decoded.putIfAbsent('projects', () => []);
      return decoded;
    } catch (_) {
      return {'folders': [], 'projects': []};
    }
  }

  Future<void> _writeIndex(String rootPath, Map<String, dynamic> index) async {
    await _ensureMetaDir(rootPath);
    await _indexFile(rootPath)
        .writeAsString(const JsonEncoder.withIndent('  ').convert(index));
  }

  Future<List<NotoFolder>> loadFolders(String rootPath) async {
    final index = await _readIndex(rootPath);
    return (index['folders'] as List)
        .map((e) => NotoFolder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFolders(String rootPath, List<NotoFolder> folders) async {
    final index = await _readIndex(rootPath);
    index['folders'] = folders.map((f) => f.toJson()).toList();
    await _writeIndex(rootPath, index);
  }

  Future<List<Project>> loadProjects(String rootPath) async {
    final index = await _readIndex(rootPath);
    return (index['projects'] as List)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProjects(String rootPath, List<Project> projects) async {
    final index = await _readIndex(rootPath);
    index['projects'] = projects.map((pr) => pr.toJson()).toList();
    await _writeIndex(rootPath, index);
  }
}
