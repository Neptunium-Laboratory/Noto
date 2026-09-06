import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../models/note.dart';
import '../models/workspace_type.dart';
import '../theme/noto_theme_mode.dart';
import 'settings_repository.dart';
import 'storage_folder_service.dart';

/// The single source of truth for everything in [AppSettings].
///
/// Screens read from this via `context.watch<SettingsController>()` and
/// call its methods to make changes — nobody touches
/// [SettingsRepository] directly. This keeps persistence, in-memory
/// state, and UI cleanly separated.
class SettingsController extends ChangeNotifier {
  SettingsController({
    SettingsRepository? repository,
    StorageFolderService? folderService,
  })  : _repository = repository ?? SettingsRepository(),
        _folderService = folderService ?? StorageFolderService();

  final SettingsRepository _repository;
  final StorageFolderService _folderService;

  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  bool _loading = true;
  bool get loading => _loading;

  /// True once a previously-chosen folder has been checked and found
  /// missing/inaccessible. Screens use this to prompt a gentle recovery
  /// flow rather than silently failing.
  bool _folderMissing = false;
  bool get folderMissing => _folderMissing;

  Future<void> load() async {
    _settings = await _repository.load();
    if (_settings.hasStorageFolder) {
      final ok = await _folderService.isFolderAccessible(_settings.storageFolderPath!);
      _folderMissing = !ok;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingComplete(true);
    _settings = _settings.copyWith(onboardingComplete: true);
    notifyListeners();
  }

  Future<String> createDefaultFolder() async {
    final path = await _folderService.createDefaultNotoFolder();
    await _setFolder(path);
    return path;
  }

  /// Returns the chosen path, or null if the user cancelled the native
  /// picker — callers should treat null as "no change", not an error.
  Future<String?> pickExistingFolder() async {
    final path = await _folderService.pickExistingFolder();
    if (path == null) return null;
    await _setFolder(path);
    return path;
  }

  Future<void> _setFolder(String path) async {
    final name = _folderService.folderDisplayName(path);
    await _repository.setStorageFolder(path: path, name: name);
    _settings = _settings.copyWith(storageFolderPath: path, storageFolderName: name);
    _folderMissing = false;
    notifyListeners();
  }

  Future<void> recheckFolder() async {
    if (!_settings.hasStorageFolder) return;
    final ok = await _folderService.isFolderAccessible(_settings.storageFolderPath!);
    _folderMissing = !ok;
    notifyListeners();
  }

  Future<void> setWorkspaceType(WorkspaceType type) async {
    await _repository.setWorkspaceType(type);
    _settings = _settings.copyWith(workspaceType: type);
    notifyListeners();
  }

  Future<void> setThemeMode(NotoThemeMode mode) async {
    await _repository.setThemeMode(mode);
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
  }

  Future<void> setAutosaveEnabled(bool value) async {
    await _repository.setAutosaveEnabled(value);
    _settings = _settings.copyWith(autosaveEnabled: value);
    notifyListeners();
  }

  Future<void> setSortOrder(NoteSortOrder order) async {
    await _repository.setSortOrder(order);
    _settings = _settings.copyWith(sortOrder: order);
    notifyListeners();
  }

  Future<void> setAppLockEnabled(bool value) async {
    await _repository.setAppLockEnabled(value);
    _settings = _settings.copyWith(appLockEnabled: value);
    notifyListeners();
  }
}
