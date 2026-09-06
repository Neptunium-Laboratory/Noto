import 'package:flutter/material.dart';

/// The brand blue used as the Material You seed color whenever dynamic
/// color from the Android system isn't available or is disabled.
///
/// Matches the blue circle in the Noto logo.
const Color notoBrandBlue = Color(0xFF3B72C4);
const Color notoBrandBlueLight = Color(0xFFA8CBFF);

/// -------------------------------------------------------------------
/// Catppuccin Mocha
///
/// Official palette: https://catppuccin.com/palette (Mocha flavor).
/// Kept as raw values here; semantic roles are mapped onto a
/// [ColorScheme] in `noto_theme.dart` so screens never touch these
/// hex values directly.
/// -------------------------------------------------------------------
class CatppuccinMocha {
  CatppuccinMocha._();

  static const rosewater = Color(0xFFF5E0DC);
  static const flamingo = Color(0xFFF2CDCD);
  static const pink = Color(0xFFF5C2E7);
  static const mauve = Color(0xFFCBA6F7);
  static const red = Color(0xFFF38BA8);
  static const maroon = Color(0xFFEBA0AC);
  static const peach = Color(0xFFFAB387);
  static const yellow = Color(0xFFF9E2AF);
  static const green = Color(0xFFA6E3A1);
  static const teal = Color(0xFF94E2D5);
  static const sky = Color(0xFF89DCEB);
  static const sapphire = Color(0xFF74C7EC);
  static const blue = Color(0xFF89B4FA);
  static const lavender = Color(0xFFB4BEFE);

  static const text = Color(0xFFCDD6F4);
  static const subtext1 = Color(0xFFBAC2DE);
  static const subtext0 = Color(0xFFA6ADC8);
  static const overlay2 = Color(0xFF9399B2);
  static const overlay1 = Color(0xFF7F849C);
  static const overlay0 = Color(0xFF6C7086);
  static const surface2 = Color(0xFF585B70);
  static const surface1 = Color(0xFF45475A);
  static const surface0 = Color(0xFF313244);
  static const base = Color(0xFF1E1E2E);
  static const mantle = Color(0xFF181825);
  static const crust = Color(0xFF11111B);
}

/// -------------------------------------------------------------------
/// System95
///
/// A custom retro terminal / CLI-lookalike palette created for Noto.
/// High-contrast, phosphor-inspired, but tuned for comfortable long-form
/// reading rather than a literal neon CRT look.
/// -------------------------------------------------------------------
class System95Palette {
  System95Palette._();

  static const background = Color(0xFF0B0E0C);
  static const panel = Color(0xFF11150F);
  static const panelAlt = Color(0xFF161B14);
  static const border = Color(0xFF2C3A2A);
  static const borderBright = Color(0xFF3F5A3A);

  static const foreground = Color(0xFFD6F5D6);
  static const foregroundMuted = Color(0xFF8FB58C);

  static const accentGreen = Color(0xFF6FE08A);
  static const accentAmber = Color(0xFFE0C36F);
  static const accentCyan = Color(0xFF6FDDE0);

  static const error = Color(0xFFE06F6F);
  static const warning = Color(0xFFE0C36F);
}
