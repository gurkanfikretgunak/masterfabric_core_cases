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
                  icon: LucideIcons.info,
                  title: 'Persistent Settings with HydratedCubit',
                  description:
                      'All settings are automatically saved and restored when the app restarts.',
                  accentColor: AppColors.primary,
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.smartphone,
                  title: 'Platform & Device Info',
                ),
                const PlatformInfoSection(),
                const SizedBox(height: 24),
                const SectionHeader(icon: LucideIcons.palette, title: 'Appearance'),
                AppearanceSection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(icon: LucideIcons.bell, title: 'Notifications'),
                NotificationsSection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.lock,
                  title: 'Security & Privacy',
                ),
                SecuritySection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.volume2,
                  title: 'Sound & Haptics',
                ),
                SoundSection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(icon: LucideIcons.wifi, title: 'Network & Data'),
                NetworkSection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.user,
                  title: 'Profile Information',
                ),
                ProfileSection(state: settingsState),
                const SizedBox(height: 24),
                const SectionHeader(icon: LucideIcons.zap, title: 'Performance'),
                PerformanceSection(viewModel: viewModel, state: settingsState),
                const SizedBox(height: 32),
                StateDisplaySection(state: settingsState),
                const SizedBox(height: 16),
                RawDataDisplaySection(state: settingsState),
              ],
            ),
          ),
        );
      },
    );
  }
}
