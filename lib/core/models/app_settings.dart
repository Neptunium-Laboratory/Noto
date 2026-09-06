import 'note.dart';
import 'workspace_type.dart';
import '../theme/noto_theme_mode.dart';

class AppSettings {
  final bool onboardingComplete;
  final String? storageFolderPath;
  final String? storageFolderName;
  final WorkspaceType workspaceType;
  final NotoThemeMode themeMode;
  final bool autosaveEnabled;
  final NoteSortOrder sortOrder;
  final bool appLockEnabled;

  const AppSettings({
    this.onboardingComplete = false,
    this.storageFolderPath,
    this.storageFolderName,
    this.workspaceType = WorkspaceType.both,
    this.themeMode = NotoThemeMode.system,
    this.autosaveEnabled = true,
    this.sortOrder = NoteSortOrder.updatedNewest,
    this.appLockEnabled = false,
  });

  bool get hasStorageFolder => storageFolderPath != null && storageFolderPath!.isNotEmpty;

  AppSettings copyWith({
    bool? onboardingComplete,
    String? storageFolderPath,
    String? storageFolderName,
    WorkspaceType? workspaceType,
    NotoThemeMode? themeMode,
    bool? autosaveEnabled,
    NoteSortOrder? sortOrder,
    bool? appLockEnabled,
  }) {
    return AppSettings(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      storageFolderPath: storageFolderPath ?? this.storageFolderPath,
      storageFolderName: storageFolderName ?? this.storageFolderName,
      workspaceType: workspaceType ?? this.workspaceType,
      themeMode: themeMode ?? this.themeMode,
      autosaveEnabled: autosaveEnabled ?? this.autosaveEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    );
  }
}
