import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/note.dart';
import '../models/workspace_type.dart';
import '../theme/noto_theme_mode.dart';

/// Persists the small pieces of app state that aren't "a note" —
/// onboarding progress, the chosen storage folder, theme, and
/// preferences. Backed by SharedPreferences, which is the right tool
/// for small key/value settings (as opposed to note content, which
/// lives in the user's chosen folder via [LocalDataStore]).
class SettingsRepository {
  static const _kOnboardingComplete = 'onboarding_complete';
  static const _kStorageFolderPath = 'storage_folder_path';
  static const _kStorageFolderName = 'storage_folder_name';
  static const _kWorkspaceType = 'workspace_type';
  static const _kThemeMode = 'theme_mode';
  static const _kAutosaveEnabled = 'autosave_enabled';
  static const _kSortOrder = 'sort_order';
  static const _kAppLockEnabled = 'app_lock_enabled';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      onboardingComplete: prefs.getBool(_kOnboardingComplete) ?? false,
      storageFolderPath: prefs.getString(_kStorageFolderPath),
      storageFolderName: prefs.getString(_kStorageFolderName),
      workspaceType:
          WorkspaceType.fromStorageKey(prefs.getString(_kWorkspaceType)),
      themeMode: NotoThemeMode.fromStorageKey(prefs.getString(_kThemeMode)),
      autosaveEnabled: prefs.getBool(_kAutosaveEnabled) ?? true,
      sortOrder: NoteSortOrder.fromStorageKey(prefs.getString(_kSortOrder)),
      appLockEnabled: prefs.getBool(_kAppLockEnabled) ?? false,
    );
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingComplete, value);
  }

  Future<void> setStorageFolder({required String path, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStorageFolderPath, path);
    await prefs.setString(_kStorageFolderName, name);
  }

  Future<void> setWorkspaceType(WorkspaceType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWorkspaceType, type.name);
  }

  Future<void> setThemeMode(NotoThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeMode, mode.name);
  }

  Future<void> setAutosaveEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutosaveEnabled, value);
  }

  Future<void> setSortOrder(NoteSortOrder order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSortOrder, order.name);
  }

  Future<void> setAppLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAppLockEnabled, value);
  }
}
