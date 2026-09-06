import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text styling for Noto.
///
/// Every other theme uses the platform's default Material 3 type scale.
/// System95 is the one theme that swaps in a monospaced face
/// (JetBrains Mono) across all visible interface text, per the brand
/// brief — headings, labels, buttons, note metadata, and editor chrome.
class NotoTypography {
  NotoTypography._();

  /// Builds a JetBrains Mono-based [TextTheme] for System95, derived from
  /// a base scheme's default text theme so sizes/weights/line-heights
  /// stay consistent with Material 3, only the font family changes.
  static TextTheme system95TextTheme(TextTheme base, Color onBackground) {
    final mono = GoogleFonts.jetBrainsMonoTextTheme(base);
    return mono.apply(
      bodyColor: onBackground,
      displayColor: onBackground,
    );
  }
}
