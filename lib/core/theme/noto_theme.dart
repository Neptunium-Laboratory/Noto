import 'package:flutter/material.dart';

import 'noto_palettes.dart';
import 'noto_theme_mode.dart';
import 'noto_typography.dart';

/// Builds the full [ThemeData] for a given [NotoThemeMode].
///
/// This is the single place that turns "which theme is selected" into
/// concrete colors, typography, shapes, and component styling. Screens
/// should only ever read from `Theme.of(context)` — never hard-code a
/// theme's colors inline.
class NotoTheme {
  NotoTheme._();

  static ThemeData build({
    required NotoThemeMode mode,
    required Brightness platformBrightness,
    ColorScheme? dynamicLight,
    ColorScheme? dynamicDark,
  }) {
    switch (mode) {
      case NotoThemeMode.system:
        final isDark = platformBrightness == Brightness.dark;
        final scheme = isDark
            ? (dynamicDark ?? _fallbackScheme(Brightness.dark))
            : (dynamicLight ?? _fallbackScheme(Brightness.light));
        return _materialTheme(scheme);

      case NotoThemeMode.light:
        return _materialTheme(
          dynamicLight ?? _fallbackScheme(Brightness.light),
        );

      case NotoThemeMode.dark:
        return _materialTheme(dynamicDark ?? _fallbackScheme(Brightness.dark));

      case NotoThemeMode.catppuccinMocha:
        return _catppuccinMochaTheme();

      case NotoThemeMode.system95:
        return _system95Theme();
    }
  }

  static ColorScheme _fallbackScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: notoBrandBlue,
      brightness: brightness,
    );
  }

  static ThemeData _materialTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }

  static ThemeData _catppuccinMochaTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: CatppuccinMocha.mauve,
      onPrimary: CatppuccinMocha.crust,
      primaryContainer: CatppuccinMocha.surface1,
      onPrimaryContainer: CatppuccinMocha.mauve,
      secondary: CatppuccinMocha.blue,
      onSecondary: CatppuccinMocha.crust,
      secondaryContainer: CatppuccinMocha.surface1,
      onSecondaryContainer: CatppuccinMocha.blue,
      tertiary: CatppuccinMocha.teal,
      onTertiary: CatppuccinMocha.crust,
      tertiaryContainer: CatppuccinMocha.surface1,
      onTertiaryContainer: CatppuccinMocha.teal,
      error: CatppuccinMocha.red,
      onError: CatppuccinMocha.crust,
      errorContainer: CatppuccinMocha.surface1,
      onErrorContainer: CatppuccinMocha.red,
      surface: CatppuccinMocha.base,
      onSurface: CatppuccinMocha.text,
      surfaceContainerLowest: CatppuccinMocha.crust,
      surfaceContainerLow: CatppuccinMocha.mantle,
      surfaceContainer: CatppuccinMocha.surface0,
      surfaceContainerHigh: CatppuccinMocha.surface1,
      surfaceContainerHighest: CatppuccinMocha.surface2,
      onSurfaceVariant: CatppuccinMocha.subtext0,
      outline: CatppuccinMocha.overlay1,
      outlineVariant: CatppuccinMocha.surface1,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: CatppuccinMocha.text,
      onInverseSurface: CatppuccinMocha.base,
      inversePrimary: CatppuccinMocha.mauve,
      surfaceTint: CatppuccinMocha.mauve,
    );

    final base = _materialTheme(scheme);
    return base.copyWith(
      cardTheme: base.cardTheme.copyWith(color: CatppuccinMocha.mantle),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: CatppuccinMocha.mantle,
        indicatorColor: CatppuccinMocha.surface1,
      ),
    );
  }

  static ThemeData _system95Theme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: System95Palette.accentGreen,
      onPrimary: System95Palette.background,
      primaryContainer: System95Palette.panelAlt,
      onPrimaryContainer: System95Palette.accentGreen,
      secondary: System95Palette.accentCyan,
      onSecondary: System95Palette.background,
      secondaryContainer: System95Palette.panelAlt,
      onSecondaryContainer: System95Palette.accentCyan,
      tertiary: System95Palette.accentAmber,
      onTertiary: System95Palette.background,
      tertiaryContainer: System95Palette.panelAlt,
      onTertiaryContainer: System95Palette.accentAmber,
      error: System95Palette.error,
      onError: System95Palette.background,
      errorContainer: System95Palette.panelAlt,
      onErrorContainer: System95Palette.error,
      surface: System95Palette.background,
      onSurface: System95Palette.foreground,
      surfaceContainerLowest: Colors.black,
      surfaceContainerLow: System95Palette.panel,
      surfaceContainer: System95Palette.panel,
      surfaceContainerHigh: System95Palette.panelAlt,
      surfaceContainerHighest: System95Palette.panelAlt,
      onSurfaceVariant: System95Palette.foregroundMuted,
      outline: System95Palette.border,
      outlineVariant: System95Palette.border,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: System95Palette.foreground,
      onInverseSurface: System95Palette.background,
      inversePrimary: System95Palette.accentGreen,
      surfaceTint: Colors.transparent,
    );

    final base = _materialTheme(scheme);
    final monoText = NotoTypography.system95TextTheme(
      base.textTheme,
      System95Palette.foreground,
    );

    return base.copyWith(
      textTheme: monoText,
      primaryTextTheme: monoText,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: System95Palette.background,
        titleTextStyle: monoText.titleLarge?.copyWith(letterSpacing: 0.5),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: System95Palette.panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: System95Palette.border),
        ),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: System95Palette.panel,
        indicatorColor: System95Palette.panelAlt,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: System95Palette.panelAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: System95Palette.border),
        ),
      ),
      dividerTheme: base.dividerTheme.copyWith(color: System95Palette.border),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          backgroundColor: System95Palette.accentGreen,
          foregroundColor: System95Palette.background,
          textStyle: monoText.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}
