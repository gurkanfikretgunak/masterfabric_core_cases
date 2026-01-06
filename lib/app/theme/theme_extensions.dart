import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'app_colors.dart';
import 'app_theme.dart';

/// Extension on BuildContext for easy theme access
extension ThemeContextExtension on BuildContext {
  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode is active (reads from SettingsCubit directly)
  bool get isDarkMode => GetIt.instance<SettingsCubit>().state.isDarkMode;

  /// Get selected primary color name
  String get primaryColorName => GetIt.instance<SettingsCubit>().state.primaryColor;

  /// Get selected accent color name
  String get accentColorName => GetIt.instance<SettingsCubit>().state.accentColor;

  /// Get the selected theme color palette
  ThemeColorPalette get themeColorPalette => AppColors.getThemeColor(primaryColorName);

  /// Get selected primary color
  Color get primaryColor => themeColorPalette.primary;

  /// Get selected primary light color
  Color get primaryLightColor => themeColorPalette.primaryLight;

  /// Get selected primary dark color
  Color get primaryDarkColor => themeColorPalette.primaryDark;

  /// Get appropriate colors based on current theme
  dynamic get colors => isDarkMode ? AppColors.dark : AppColors.light;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;
}

/// Extension for getting theme-aware colors
extension ThemeColors on BuildContext {
  // Backgrounds
  Color get scaffoldColor => isDarkMode ? AppColors.dark.scaffold : AppColors.light.scaffold;
  Color get cardColor => isDarkMode ? AppColors.dark.card : AppColors.light.card;
  Color get cardSecondaryColor => isDarkMode ? AppColors.dark.cardSecondary : AppColors.light.cardSecondary;
  Color get surfaceColor => isDarkMode ? AppColors.dark.surface : AppColors.light.surface;
  Color get surfaceVariantColor => isDarkMode ? AppColors.dark.surfaceVariant : AppColors.light.surfaceVariant;

  // Text
  Color get textPrimaryColor => isDarkMode ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
  Color get textSecondaryColor => isDarkMode ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
  Color get textTertiaryColor => isDarkMode ? AppColors.dark.textTertiary : AppColors.light.textTertiary;

  // Borders
  Color get borderColor => isDarkMode ? AppColors.dark.border : AppColors.light.border;
  Color get borderLightColor => isDarkMode ? AppColors.dark.borderLight : AppColors.light.borderLight;
  Color get dividerColor => isDarkMode ? AppColors.dark.divider : AppColors.light.divider;

  // Icons
  Color get iconColor => isDarkMode ? AppColors.dark.icon : AppColors.light.icon;
  Color get iconSecondaryColor => isDarkMode ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary;

  // Shadows
  Color get shadowColor => isDarkMode ? AppColors.dark.shadow : AppColors.light.shadow;

  // Code
  Color get codeBackgroundColor => isDarkMode ? AppColors.dark.codeBackground : AppColors.light.codeBackground;
  Color get codeHeaderColor => isDarkMode ? AppColors.dark.codeHeader : AppColors.light.codeHeader;
  Color get codeTextColor => isDarkMode ? AppColors.dark.codeText : AppColors.light.codeText;

  // Info
  Color get infoBackgroundColor => isDarkMode ? AppColors.dark.infoBackground : AppColors.light.infoBackground;
  Color get infoBorderColor => isDarkMode ? AppColors.dark.infoBorder : AppColors.light.infoBorder;
  Color get infoIconColor => isDarkMode ? AppColors.dark.infoIcon : AppColors.light.infoIcon;
}

/// Common widget builder helpers
class ThemedWidgets {
  ThemedWidgets._();

  /// Build a themed card container
  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Build a themed icon container using selected primary color
  static Widget iconBox({
    required BuildContext context,
    required IconData icon,
    Color? color,
    Color? backgroundColor,
    double size = 44,
    double iconSize = 20,
  }) {
    final iconColor = color ?? context.primaryColor;
    final bgColor = backgroundColor ?? context.primaryLightColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.isDarkMode ? iconColor.withValues(alpha: 0.2) : bgColor,
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}
