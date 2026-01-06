import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer, AppRoutes;
import 'package:masterfabric_core_cases/views/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_cases/views/home/widgets/raw_settings_card.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'package:masterfabric_core_cases/app/routes.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Home screen view using MasterViewCubit from masterfabric_core
class HomeView extends MasterViewCubit<HomeCubit, HomeState> {
  HomeView({super.key, required super.goRoute})
      : super(
          currentView: MasterViewCubitTypes.content,
          arguments: const {'title': 'Home'},
        );

  @override
  Future<void> initialContent(HomeCubit viewModel, BuildContext context) async {
    debugPrint('Home View Initialized with MasterViewCubit');
    await viewModel.initialize();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeCubit viewModel,
    HomeState state,
  ) {
    final settingsCubit = GetIt.instance<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final primary = AppColors.getThemeColor(settingsState.primaryColor);
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
            centerTitle: false,
            title: Text(
              'MasterFabric Core',
              style: TextStyle(
                color: appBarFg,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            iconTheme: IconThemeData(color: iconColor),
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
                  settingsCubit.toggleDarkMode();
                },
              ),
              // Settings button
              IconButton(
                icon: Icon(LucideIcons.settings, size: 20, color: iconColor),
                tooltip: 'Settings',
                onPressed: () => goRoute(AppRoutes.settings),
              ),
            ],
          ),
          body: _HomeContent(
            viewModel: viewModel,
            homeState: state,
            settingsState: settingsState,
            goRoute: goRoute,
            primary: primary,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: viewModel.incrementCounter,
            tooltip: 'Increment',
            backgroundColor: primary.primary,
            foregroundColor: Colors.white,
            child: const Icon(LucideIcons.plus, size: 22),
          ),
        );
      },
    );
  }
}

/// Home content widget
class _HomeContent extends StatelessWidget {
  final HomeCubit viewModel;
  final HomeState homeState;
  final SettingsState settingsState;
  final Function(String) goRoute;
  final ThemeColorPalette primary;

  const _HomeContent({
    required this.viewModel,
    required this.homeState,
    required this.settingsState,
    required this.goRoute,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = settingsState.isDarkMode;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Card
          _ThemedCard(
            isDark: isDark,
            child: Column(
              children: [
                _buildIconBox(
                  isDark: isDark,
                  icon: LucideIcons.circleCheck,
                  color: AppColors.success,
                  backgroundColor: AppColors.successLight,
                  size: 56,
                  iconSize: 28,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Successfully passed through Splash Screen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Counter Card
          _ThemedCard(
            isDark: isDark,
            child: Row(
              children: [
                _buildIconBox(
                  isDark: isDark,
                  icon: LucideIcons.hash,
                  color: primary.primary,
                  backgroundColor: primary.primaryLight,
                  size: 48,
                  iconSize: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Counter',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${homeState.counter}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: primary.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: viewModel.resetCounter,
                  icon: Icon(
                    LucideIcons.rotateCcw,
                    size: 18,
                    color: isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary,
                  ),
                  tooltip: 'Reset',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Navigation Section
          Text(
            'Navigate',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _NavigationTile(
            isDark: isDark,
            icon: LucideIcons.settings,
            title: 'Settings',
            subtitle: 'HydratedCubit persistent state',
            onTap: () => goRoute(AppRoutes.settings),
            iconColor: primary.primary,
            iconBgColor: primary.primaryLight,
          ),
          const SizedBox(height: 10),
          _NavigationTile(
            isDark: isDark,
            icon: LucideIcons.bluetooth,
            title: 'Web APIs',
            subtitle: 'Bluetooth & Passkeys integration',
            onTap: () => goRoute(AppRoutes.webApis),
            iconColor: AppColors.purple,
            iconBgColor: AppColors.purpleLight,
          ),
          const SizedBox(height: 32),

          // Divider with explanation
          _SectionDivider(
            isDark: isDark,
            icon: LucideIcons.database,
            title: 'Developer Debug',
            description:
                'This section shows the raw state data from HydratedCubit. '
                'It demonstrates how state persistence works - all settings '
                'are automatically serialized to JSON and saved locally.',
          ),
          const SizedBox(height: 16),

          // Raw Settings Card
          const RawSettingsCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildIconBox({
    required bool isDark,
    required IconData icon,
    Color? color,
    Color? backgroundColor,
    double size = 44,
    double iconSize = 20,
  }) {
    final iconColor = color ?? primary.primary;
    final bgColor = backgroundColor ?? primary.primaryLight;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? iconColor.withValues(alpha: 0.2) : bgColor,
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}

/// Themed card container with standard radius
class _ThemedCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _ThemedCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }
}

/// Navigation tile for menu items
class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final bool isDark;

  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;
    final bgColor = iconBgColor ?? AppColors.primaryLight;
    final cardColor = isDark ? AppColors.dark.card : AppColors.light.card;
    final borderColor = isDark ? AppColors.dark.border : AppColors.light.border;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final iconSecondary = isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(kRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? color.withValues(alpha: 0.2) : bgColor,
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section divider with icon and explanation
class _SectionDivider extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _SectionDivider({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark ? AppColors.dark.divider : AppColors.light.divider;
    final surfaceVariant = isDark ? AppColors.dark.surfaceVariant : AppColors.light.surfaceVariant;
    final iconSecondary = isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final infoBackground = isDark ? AppColors.dark.infoBackground : AppColors.light.infoBackground;
    final infoBorder = isDark ? AppColors.dark.infoBorder : AppColors.light.infoBorder;
    final infoIcon = isDark ? AppColors.dark.infoIcon : AppColors.light.infoIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: surfaceVariant,
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: iconSecondary),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Divider(color: dividerColor)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: infoBackground,
            borderRadius: BorderRadius.circular(kRadius),
            border: Border.all(color: infoBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.lightbulb,
                size: 16,
                color: infoIcon,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
