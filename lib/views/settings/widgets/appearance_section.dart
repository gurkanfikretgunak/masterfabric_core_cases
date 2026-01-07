import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Appearance settings section (theme, language, fonts, colors)
class AppearanceSection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const AppearanceSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final currentPrimary = AppColors.getThemeColor(state.primaryColor);
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.dark.card : AppColors.light.card,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.dark.shadow : AppColors.light.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dark Mode Toggle
          SettingSwitchTile(
            title: 'Dark Mode',
            subtitle:
                state.isDarkMode ? 'Dark theme active' : 'Light theme active',
            value: state.isDarkMode,
            icon: state.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
            onChanged: (_) => viewModel.toggleDarkMode(),
          ),
          _buildDivider(isDark),
          
          // Theme Color Selector
          _ThemeColorSelector(
            viewModel: viewModel,
            state: state,
            currentPrimary: currentPrimary,
          ),
          _buildDivider(isDark),
          
          // Language Selector
          _LanguageSelector(viewModel: viewModel, state: state),
          _buildDivider(isDark),
          
          // Font Size
          SettingSliderTile(
            title: 'Font Size',
            subtitle: '${state.fontSize.toStringAsFixed(0)}px',
            value: state.fontSize,
            min: 10,
            max: 24,
            divisions: 14,
            icon: LucideIcons.type,
            onChanged: viewModel.updateFontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.dark.divider : AppColors.light.divider,
    );
  }
}

/// Theme color selector widget
class _ThemeColorSelector extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;
  final ThemeColorPalette currentPrimary;

  const _ThemeColorSelector({
    required this.viewModel,
    required this.state,
    required this.currentPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final iconSecondary = isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary;

    final cardColor = isDark ? AppColors.dark.card : AppColors.light.card;
    
    return ExpansionTile(
      backgroundColor: cardColor,
      collapsedBackgroundColor: cardColor,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentPrimary.primary.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(LucideIcons.palette, color: currentPrimary.primary, size: 20),
      ),
      title: Text(
        'Theme Color',
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: currentPrimary.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            currentPrimary.name,
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
      iconColor: iconSecondary,
      collapsedIconColor: iconSecondary,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _ColorGrid(
            viewModel: viewModel,
            state: state,
          ),
        ),
      ],
    );
  }
}

/// Color selection grid
class _ColorGrid extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const _ColorGrid({
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final colors = AppColors.themeColors.entries.toList();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((entry) {
        final isSelected = state.primaryColor == entry.key;
        final palette = entry.value;

        return GestureDetector(
          onTap: () => viewModel.changePrimaryColor(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(kRadius),
              border: Border.all(
                color: isSelected 
                    ? palette.primary 
                    : (isDark ? AppColors.dark.border : AppColors.light.border),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: palette.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  palette.name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? palette.primary
                        : (isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const _LanguageSelector({required this.viewModel, required this.state});

  String _getLanguageName(String code) => switch (code) {
        'tr' => 'Türkçe',
        'en' => 'English',
        'de' => 'Deutsch',
        'fr' => 'Français',
        _ => code,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final primary = AppColors.getThemeColor(state.primaryColor).primary;
    
    final cardColor = isDark ? AppColors.dark.card : AppColors.light.card;
    
    return ExpansionTile(
      backgroundColor: cardColor,
      collapsedBackgroundColor: cardColor,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(LucideIcons.globe, color: primary, size: 20),
      ),
      title: Text(
        'Language',
        style: TextStyle(
          color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        _getLanguageName(state.language),
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
        ),
      ),
      iconColor: isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary,
      collapsedIconColor: isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary,
      children: [
        for (final lang in ['tr', 'en', 'de', 'fr'])
          RadioListTile<String>(
            title: Text(
              _getLanguageName(lang),
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
            ),
            value: lang,
            groupValue: state.language,
            activeColor: primary,
            onChanged: (value) {
              if (value != null) viewModel.changeLanguage(value);
            },
          ),
      ],
    );
  }
}
