import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'package:masterfabric_core_cases/views/settings/widgets/widgets.dart';

/// Settings View - Demonstrates HydratedCubit for persistent state
class SettingsView
    extends MasterViewHydratedCubit<SettingsCubit, SettingsState> {
  SettingsView({super.key, required super.goRoute})
    : super(
        currentView: MasterViewHydratedCubitTypes.content,
        arguments: const {'title': 'Settings'},
        // Don't use coreAppBar - we'll build it inside viewContent with BlocBuilder
      );

  @override
  Future<void> initialContent(
    SettingsCubit viewModel,
    BuildContext context,
  ) async {
    debugPrint('Settings View Initialized with HydratedCubit');
  }

  @override
  Widget viewContent(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    // Use BlocBuilder to listen to theme changes
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: viewModel,
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final appBarBg = isDark ? AppColors.dark.appBar : AppColors.light.appBar;
        final appBarFg = isDark ? AppColors.dark.appBarForeground : AppColors.light.appBarForeground;
        final iconColor = isDark ? AppColors.dark.icon : AppColors.light.icon;
        final scaffoldBg = isDark ? AppColors.dark.scaffold : AppColors.light.scaffold;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarBg,
            foregroundColor: appBarFg,
            leading: IconButton(
              icon: Icon(LucideIcons.arrowLeft, color: iconColor),
              onPressed: () => goRoute('/home'),
              tooltip: 'Back to Home',
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.settings, color: appBarFg, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: appBarFg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              // Theme toggle button
              IconButton(
                icon: Icon(
                  isDark ? LucideIcons.sun : LucideIcons.moon,
                  size: 20,
                  color: iconColor,
                ),
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                onPressed: () {
                  viewModel.toggleDarkMode();
                },
              ),
              // Reset button
              IconButton(
                icon: Icon(LucideIcons.rotateCcw, color: iconColor, size: 20),
                onPressed: () {
                  viewModel.resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isDark ? AppColors.dark.card : AppColors.success,
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.check, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Settings reset')),
                        ],
                      ),
                    ),
                  );
                },
                tooltip: 'Reset to Defaults',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  key: ValueKey('info_card_${isDark}'),
                  icon: LucideIcons.info,
                  title: 'Persistent Settings with HydratedCubit',
                  description:
                      'All settings are automatically saved and restored when the app restarts.',
                  accentColor: AppColors.getThemeColor(settingsState.primaryColor).primary,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('platform_header_${isDark}'),
                  icon: LucideIcons.smartphone,
                  title: 'Platform & Device Info',
                ),
                PlatformInfoSection(key: ValueKey('platform_section_${isDark}')),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('appearance_header_${isDark}'),
                  icon: LucideIcons.palette,
                  title: 'Appearance',
                ),
                AppearanceSection(
                  key: ValueKey('appearance_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('notifications_header_${isDark}'),
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                ),
                NotificationsSection(
                  key: ValueKey('notifications_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('security_header_${isDark}'),
                  icon: LucideIcons.lock,
                  title: 'Security & Privacy',
                ),
                SecuritySection(
                  key: ValueKey('security_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('sound_header_${isDark}'),
                  icon: LucideIcons.volume2,
                  title: 'Sound & Haptics',
                ),
                SoundSection(
                  key: ValueKey('sound_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('network_header_${isDark}'),
                  icon: LucideIcons.wifi,
                  title: 'Network & Data',
                ),
                NetworkSection(
                  key: ValueKey('network_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('profile_header_${isDark}'),
                  icon: LucideIcons.user,
                  title: 'Profile Information',
                ),
                ProfileSection(
                  key: ValueKey('profile_section_${isDark}'),
                  state: settingsState,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  key: ValueKey('performance_header_${isDark}'),
                  icon: LucideIcons.zap,
                  title: 'Performance',
                ),
                PerformanceSection(
                  key: ValueKey('performance_section_${isDark}'),
                  viewModel: viewModel,
                  state: settingsState,
                ),
                const SizedBox(height: 32),
                StateDisplaySection(
                  key: ValueKey('state_display_${isDark}'),
                  state: settingsState,
                ),
                const SizedBox(height: 16),
                RawDataDisplaySection(
                  key: ValueKey('raw_data_${isDark}'),
                  state: settingsState,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
