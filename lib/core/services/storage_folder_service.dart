import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Handles everything related to *where on the device* notes live.
///
/// Noto never asks the user to type a path. There are exactly two ways
/// a folder gets chosen:
///  - [createDefaultNotoFolder] — a ready-made "Noto" folder in the app's
///    own storage area, for the "recommended" onboarding path.
///  - [pickExistingFolder] — the native Android folder picker (Storage
///    Access Framework), for users who want to choose their own location.
class StorageFolderService {
  /// Creates (if needed) and returns the path to a default "Noto" folder.
  /// This is the fast, no-dialog path recommended to most users.
  Future<String> createDefaultNotoFolder() async {
    final base = await getApplicationDocumentsDirectory();
    final notoDir = Directory(p.join(base.path, 'Noto'));
    if (!await notoDir.exists()) {
      await notoDir.create(recursive: true);
    }
    return notoDir.path;
  }

  /// Opens the native Android folder picker so the user can choose an
  /// existing folder anywhere they have access to. Returns null if the
  /// user cancels or the platform denies access — callers should treat
  /// that as "stay where you are", never as a dead end.
  Future<String?> pickExistingFolder() async {
    try {
      return await FilePicker.getDirectoryPath(
        dialogTitle: 'Choose a folder for your notes',
      );
    } catch (_) {
      return null;
    }
  }

  /// Whether a previously-chosen folder is still there and readable.
  /// Folders can disappear if they were on removable storage, synced
  /// away, or manually deleted — this lets the app recover gracefully
  /// instead of crashing on a missing directory.
  Future<bool> isFolderAccessible(String path) async {
    try {
      final dir = Directory(path);
      if (!await dir.exists()) return false;
      // A cheap read-access probe.
      await dir.list().isEmpty;
      return true;
    } catch (_) {
      return false;
    }
  }

  String folderDisplayName(String path) {
    final name = p.basename(path);
    return name.isEmpty ? path : name;
  }
}
