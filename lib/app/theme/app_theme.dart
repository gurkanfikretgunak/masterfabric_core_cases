import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Standard border radius used across the app
const double kRadius = 7.0;

/// App Theme configuration for Light and Dark modes
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData light(String primaryColorName) {
    final colors = AppColors.light;
    final primaryColor = AppColors.getThemeColor(primaryColorName);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.scaffold,
      primaryColor: primaryColor.primary,
      colorScheme: ColorScheme.light(
        primary: primaryColor.primary,
        secondary: AppColors.purple,
        surface: colors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colors.textPrimary,
        onError: Colors.white,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: colors.appBar,
        foregroundColor: colors.appBarForeground,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: colors.appBarForeground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colors.icon,
          size: 20,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
          side: BorderSide(color: colors.border),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colors.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.fab,
        foregroundColor: colors.fabForeground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius + 5),
        ),
      ),

      // Text
      textTheme: _buildTextTheme(colors.textPrimary, colors.textSecondary),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),

      // Icon
      iconTheme: IconThemeData(
        color: colors.icon,
        size: 20,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        tileColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.primary;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.primaryLight;
          }
          return Colors.grey.shade300;
        }),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: AppColors.getThemeColor('blue').primary),
        ),
      ),

      // Expansion Tile
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: colors.card,
        collapsedBackgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData dark(String primaryColorName) {
    final colors = AppColors.dark;
    final primaryColor = AppColors.getThemeColor(primaryColorName);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.scaffold,
      primaryColor: primaryColor.primary,
      colorScheme: ColorScheme.dark(
        primary: primaryColor.primary,
        secondary: AppColors.purple,
        surface: colors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colors.textPrimary,
        onError: Colors.white,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: colors.appBar,
        foregroundColor: colors.appBarForeground,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: colors.appBarForeground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colors.icon,
          size: 20,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
          side: BorderSide(color: colors.border),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colors.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.fab,
        foregroundColor: colors.fabForeground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius + 5),
        ),
      ),

      // Text
      textTheme: _buildTextTheme(colors.textPrimary, colors.textSecondary),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
      ),

      // Icon
      iconTheme: IconThemeData(
        color: colors.icon,
        size: 20,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        tileColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.primary;
          }
          return Colors.grey.shade600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.primary.withValues(alpha: 0.5);
          }
          return Colors.grey.shade700;
        }),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.cardSecondary,
        contentTextStyle: TextStyle(color: colors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: primaryColor.primary),
        ),
      ),

      // Expansion Tile
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: colors.card,
        collapsedBackgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: primary),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: primary),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: primary),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: primary),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: primary),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: secondary),
    );
  }
}

