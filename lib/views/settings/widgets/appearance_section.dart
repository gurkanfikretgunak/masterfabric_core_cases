import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    return Card(
      child: Column(
        children: [
          SettingSwitchTile(
            title: 'Dark Mode',
            subtitle:
                state.isDarkMode ? 'Dark theme active' : 'Light theme active',
            value: state.isDarkMode,
            icon: state.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
            onChanged: (_) => viewModel.toggleDarkMode(),
          ),
          const Divider(height: 1),
          _LanguageSelector(viewModel: viewModel, state: state),
          const Divider(height: 1),
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
          const Divider(height: 1),
          _ColorSelector(
            viewModel: viewModel,
            state: state,
            isPrimary: true,
          ),
          const Divider(height: 1),
          _ColorSelector(
            viewModel: viewModel,
            state: state,
            isPrimary: false,
          ),
        ],
      ),
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
    return ExpansionTile(
      leading: Icon(LucideIcons.globe, color: Theme.of(context).primaryColor),
      title: const Text('Language'),
      subtitle: Text(_getLanguageName(state.language)),
      children: [
        for (final lang in ['tr', 'en', 'de', 'fr'])
          RadioListTile<String>(
            title: Text(_getLanguageName(lang)),
            value: lang,
            groupValue: state.language,
            onChanged: (value) {
              if (value != null) viewModel.changeLanguage(value);
            },
          ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;
  final bool isPrimary;

  const _ColorSelector({
    required this.viewModel,
    required this.state,
    required this.isPrimary,
  });

  static const _colors = {
    'blue': Colors.blue,
    'red': Colors.red,
    'green': Colors.green,
    'purple': Colors.purple,
    'orange': Colors.orange,
  };

  String _getColorName(String color) => switch (color) {
        'blue' => 'Blue',
        'red' => 'Red',
        'green' => 'Green',
        'purple' => 'Purple',
        'orange' => 'Orange',
        _ => color,
      };

  @override
  Widget build(BuildContext context) {
    final currentColor = isPrimary ? state.primaryColor : state.accentColor;

    return ExpansionTile(
      leading:
          Icon(LucideIcons.palette, color: Theme.of(context).primaryColor),
      title: Text(isPrimary ? 'Primary Color' : 'Accent Color'),
      subtitle: Text(_getColorName(currentColor)),
      children: _colors.entries.map((entry) {
        return RadioListTile<String>(
          title: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(_getColorName(entry.key)),
            ],
          ),
          value: entry.key,
          groupValue: currentColor,
          onChanged: (value) {
            if (value != null) {
              isPrimary
                  ? viewModel.changePrimaryColor(value)
                  : viewModel.changeAccentColor(value);
            }
          },
        );
      }).toList(),
    );
  }
}

