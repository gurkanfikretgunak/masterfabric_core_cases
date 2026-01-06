import 'package:flutter/material.dart';

/// App color palette for light and dark themes
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const light = _LightColors();

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const dark = _DarkColors();

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME COLORS - Selectable via Settings
  // ═══════════════════════════════════════════════════════════════════════════

  /// Available theme colors
  static const Map<String, ThemeColorPalette> themeColors = {
    'blue': ThemeColorPalette(
      name: 'Blue',
      primary: Color(0xFF2196F3),
      primaryLight: Color(0xFFE3F2FD),
      primaryDark: Color(0xFF1976D2),
    ),
    'red': ThemeColorPalette(
      name: 'Red',
      primary: Color(0xFFF44336),
      primaryLight: Color(0xFFFFEBEE),
      primaryDark: Color(0xFFD32F2F),
    ),
    'green': ThemeColorPalette(
      name: 'Green',
      primary: Color(0xFF4CAF50),
      primaryLight: Color(0xFFE8F5E9),
      primaryDark: Color(0xFF388E3C),
    ),
    'purple': ThemeColorPalette(
      name: 'Purple',
      primary: Color(0xFF7C4DFF),
      primaryLight: Color(0xFFEDE7F6),
      primaryDark: Color(0xFF651FFF),
    ),
    'orange': ThemeColorPalette(
      name: 'Orange',
      primary: Color(0xFFFF9800),
      primaryLight: Color(0xFFFFF3E0),
      primaryDark: Color(0xFFF57C00),
    ),
    'teal': ThemeColorPalette(
      name: 'Teal',
      primary: Color(0xFF009688),
      primaryLight: Color(0xFFE0F2F1),
      primaryDark: Color(0xFF00796B),
    ),
    'pink': ThemeColorPalette(
      name: 'Pink',
      primary: Color(0xFFE91E63),
      primaryLight: Color(0xFFFCE4EC),
      primaryDark: Color(0xFFC2185B),
    ),
    'indigo': ThemeColorPalette(
      name: 'Indigo',
      primary: Color(0xFF3F51B5),
      primaryLight: Color(0xFFE8EAF6),
      primaryDark: Color(0xFF303F9F),
    ),
  };

  /// Get theme color palette by name
  static ThemeColorPalette getThemeColor(String colorName) {
    return themeColors[colorName] ?? themeColors['blue']!;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFAULT ACCENT COLORS (for status indicators)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color cyanLight = Color(0xFFE0F7FA);

  // Legacy static colors for backward compatibility
  static Color primary = const Color(0xFF2196F3);
  static Color primaryLight = const Color(0xFFE3F2FD);
  static const Color purple = Color(0xFF7C4DFF);
  static const Color purpleLight = Color(0xFFEDE7F6);
  static const Color teal = Color(0xFF009688);
  static const Color tealLight = Color(0xFFE0F2F1);
}

/// Theme color palette definition
class ThemeColorPalette {
  final String name;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  const ThemeColorPalette({
    required this.name,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
  });
}

/// Light theme color definitions
class _LightColors {
  const _LightColors();

  // Backgrounds
  Color get scaffold => const Color(0xFFF8F9FA);
  Color get card => Colors.white;
  Color get cardSecondary => const Color(0xFFF5F5F5);
  Color get surface => Colors.white;
  Color get surfaceVariant => const Color(0xFFF0F0F0);
  Color get dialogBackground => Colors.white;

  // AppBar
  Color get appBar => Colors.white;
  Color get appBarForeground => const Color(0xFF1A1A1A);

  // Text
  Color get textPrimary => const Color(0xFF1A1A1A);
  Color get textSecondary => const Color(0xFF757575);
  Color get textTertiary => const Color(0xFF9E9E9E);
  Color get textInverse => Colors.white;

  // Borders & Dividers
  Color get border => const Color(0xFFE0E0E0);
  Color get borderLight => const Color(0xFFF0F0F0);
  Color get divider => const Color(0xFFE0E0E0);

  // Interactive
  Color get ripple => Colors.black12;
  Color get hover => const Color(0x0A000000);
  Color get pressed => const Color(0x1A000000);

  // Icons
  Color get icon => const Color(0xFF616161);
  Color get iconSecondary => const Color(0xFF9E9E9E);

  // FAB
  Color get fab => const Color(0xFF1A1A1A);
  Color get fabForeground => Colors.white;

  // Shadows
  Color get shadow => Colors.black.withValues(alpha: 0.04);
  Color get shadowMedium => Colors.black.withValues(alpha: 0.08);

  // Code block
  Color get codeBackground => const Color(0xFF1E1E1E);
  Color get codeHeader => const Color(0xFF2D2D2D);
  Color get codeText => const Color(0xFF4CAF50);

  // Info box
  Color get infoBackground => const Color(0xFFFFF8E1);
  Color get infoBorder => const Color(0xFFFFE082);
  Color get infoIcon => const Color(0xFFF9A825);
}

/// Dark theme color definitions
class _DarkColors {
  const _DarkColors();

  // Backgrounds
  Color get scaffold => const Color(0xFF121212);
  Color get card => const Color(0xFF1E1E1E);
  Color get cardSecondary => const Color(0xFF2D2D2D);
  Color get surface => const Color(0xFF1E1E1E);
  Color get surfaceVariant => const Color(0xFF2D2D2D);
  Color get dialogBackground => const Color(0xFF1E1E1E);

  // AppBar
  Color get appBar => const Color(0xFF1E1E1E);
  Color get appBarForeground => Colors.white;

  // Text
  Color get textPrimary => const Color(0xFFE0E0E0);
  Color get textSecondary => const Color(0xFFB0B0B0);
  Color get textTertiary => const Color(0xFF808080);
  Color get textInverse => const Color(0xFF1A1A1A);

  // Borders & Dividers
  Color get border => const Color(0xFF3D3D3D);
  Color get borderLight => const Color(0xFF2D2D2D);
  Color get divider => const Color(0xFF3D3D3D);

  // Interactive
  Color get ripple => Colors.white12;
  Color get hover => const Color(0x0AFFFFFF);
  Color get pressed => const Color(0x1AFFFFFF);

  // Icons
  Color get icon => const Color(0xFFB0B0B0);
  Color get iconSecondary => const Color(0xFF808080);

  // FAB
  Color get fab => Colors.white;
  Color get fabForeground => const Color(0xFF1A1A1A);

  // Shadows
  Color get shadow => Colors.black.withValues(alpha: 0.2);
  Color get shadowMedium => Colors.black.withValues(alpha: 0.3);

  // Code block
  Color get codeBackground => const Color(0xFF0D0D0D);
  Color get codeHeader => const Color(0xFF1A1A1A);
  Color get codeText => const Color(0xFF4CAF50);

  // Info box
  Color get infoBackground => const Color(0xFF2D2D2D);
  Color get infoBorder => const Color(0xFF5D5D5D);
  Color get infoIcon => const Color(0xFFFFB74D);
}
