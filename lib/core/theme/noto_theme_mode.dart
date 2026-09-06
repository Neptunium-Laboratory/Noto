/// The five appearance options a Noto user can choose from.
///
/// [system] follows the Android device's light/dark setting and uses
/// Material You dynamic color when it's available.
enum NotoThemeMode {
  system,
  light,
  dark,
  catppuccinMocha,
  system95;

  String get label {
    switch (this) {
      case NotoThemeMode.system:
        return 'System';
      case NotoThemeMode.light:
        return 'Light';
      case NotoThemeMode.dark:
        return 'Dark';
      case NotoThemeMode.catppuccinMocha:
        return 'Catppuccin Mocha';
      case NotoThemeMode.system95:
        return 'System95';
    }
  }

  String get description {
    switch (this) {
      case NotoThemeMode.system:
        return "Follows your device's theme";
      case NotoThemeMode.light:
        return 'Bright and clean';
      case NotoThemeMode.dark:
        return 'Easy on the eyes at night';
      case NotoThemeMode.catppuccinMocha:
        return 'A cozy, soft dark theme';
      case NotoThemeMode.system95:
        return 'A retro terminal look';
    }
  }

  /// Whether this theme uses a fixed (non-dynamic-color) palette.
  bool get isFixedPalette =>
      this == NotoThemeMode.catppuccinMocha || this == NotoThemeMode.system95;

  static NotoThemeMode fromStorageKey(String? key) {
    return NotoThemeMode.values.firstWhere(
      (m) => m.name == key,
      orElse: () => NotoThemeMode.system,
    );
  }
}
