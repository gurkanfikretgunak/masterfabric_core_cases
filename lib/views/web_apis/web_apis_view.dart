import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_state.dart';
import 'package:masterfabric_core_cases/views/web_apis/widgets/widgets.dart';

/// Web APIs View - Demonstrates Bluetooth and Passkey Web APIs
class WebApisView extends MasterViewHydratedCubit<WebApisCubit, WebApisState> {
  WebApisView({super.key, required super.goRoute})
    : super(
        currentView: MasterViewHydratedCubitTypes.content,
        arguments: const {'title': 'Web APIs'},
        // Don't use coreAppBar - we'll build it inside viewContent with BlocBuilder
      );

  @override
  Future<void> initialContent(
    WebApisCubit viewModel,
    BuildContext context,
  ) async {
    debugPrint('Web APIs View Initialized');
    viewModel.recheckApiSupport();
  }

  @override
  Widget viewContent(
    BuildContext context,
    WebApisCubit viewModel,
    WebApisState state,
  ) {
    final settingsCubit = GetIt.instance<SettingsCubit>();

    // Use BlocBuilder to listen to theme changes
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
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
                Icon(LucideIcons.radio, color: appBarFg, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Web APIs Demo',
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
                  settingsCubit.toggleDarkMode();
                },
              ),
              // Info button
              IconButton(
                icon: Icon(LucideIcons.info, color: iconColor, size: 20),
                onPressed: () => _showInfoDialog(context, isDark),
                tooltip: 'Info',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoCard(state: state, isDark: isDark),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.bluetooth,
                  title: 'Web Bluetooth API',
                ),
                BluetoothSection(viewModel: viewModel, state: state),
                const SizedBox(height: 24),
                const SectionHeader(
                  icon: LucideIcons.key,
                  title: 'WebAuthn (Passkeys)',
                ),
                PasskeySection(viewModel: viewModel, state: state),
                const SizedBox(height: 32),
                _RawStateDisplay(state: state, isDark: isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.dark.dialogBackground : AppColors.light.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius + 5),
        ),
        title: Row(
          children: [
            Icon(
              LucideIcons.info, 
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Web APIs Info',
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'This feature demonstrates Chrome Web APIs:\n\n'
          '• Web Bluetooth API for device scanning\n'
          '• WebAuthn API for passkey authentication\n\n'
          'Note: These APIs only work in Chrome/Edge browsers with HTTPS.',
          style: TextStyle(
            color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final WebApisState state;
  final bool isDark;

  const _InfoCard({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.dark.card : AppColors.light.card;
    final shadowColor = isDark ? AppColors.dark.shadow : AppColors.light.shadow;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.primary.withValues(alpha: 0.2) 
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                child: Icon(LucideIcons.chrome, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chrome Web APIs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bluetooth scanning & passwordless authentication (macOS Touch ID supported)',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatusChip(
                icon: LucideIcons.bluetooth,
                label: 'Bluetooth',
                enabled: state.bluetoothEnabled,
              ),
              StatusChip(
                icon: LucideIcons.key,
                label: 'Passkeys',
                enabled: state.passkeyEnabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RawStateDisplay extends StatelessWidget {
  final WebApisState state;
  final bool isDark;

  const _RawStateDisplay({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.dark.card : AppColors.light.card;
    final shadowColor = isDark ? AppColors.dark.shadow : AppColors.light.shadow;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final codeBackground = isDark ? AppColors.dark.codeBackground : AppColors.light.codeBackground;
    final codeText = isDark ? AppColors.dark.codeText : AppColors.light.codeText;
    final iconSecondary = isDark ? AppColors.dark.iconSecondary : AppColors.light.iconSecondary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.warning.withValues(alpha: 0.2) 
                  : AppColors.warningLight,
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(LucideIcons.code, color: AppColors.warning, size: 18),
          ),
          title: Text(
            'Raw State Data (Persisted)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          subtitle: Text(
            'HydratedCubit state stored in local storage',
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),
          iconColor: iconSecondary,
          collapsedIconColor: iconSecondary,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: codeBackground,
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: SelectableText(
                state.toString(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: codeText,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
