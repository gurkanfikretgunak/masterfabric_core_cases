import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/hive_ce/cubit/hive_ce_cubit.dart';
import 'package:masterfabric_core_cases/views/hive_ce/cubit/hive_ce_state.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Hive CE View - Demonstrates HiveCeHelper usage from masterfabric_core
class HiveCeView extends MasterViewCubit<HiveCeCubit, HiveCeState> {
  HiveCeView({super.key, required super.goRoute})
      : super(
          currentView: MasterViewCubitTypes.content,
          arguments: const {'title': 'Hive CE'},
        );

  @override
  Future<void> initialContent(HiveCeCubit viewModel, BuildContext context) async {
    debugPrint('Hive CE View Initialized');
    await viewModel.initialize();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HiveCeCubit viewModel,
    HiveCeState state,
  ) {
    final settingsCubit = GetIt.instance<SettingsCubit>();

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
                Icon(LucideIcons.database, color: appBarFg, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hive CE Helper',
                  style: TextStyle(
                    color: appBarFg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      InfoCard(
                        key: ValueKey('info_card_${isDark}'),
                        icon: LucideIcons.info,
                        title: 'Hive CE Database',
                        description:
                            'Hive CE is a lightweight, fast key-value database. '
                            'This demo shows how to use Hive CE for local data storage. '
                            'Data persists across app restarts.',
                        accentColor: AppColors.cyan,
                      ),
                      const SizedBox(height: 24),

                      // How to Use Section
                      SectionHeader(
                        key: ValueKey('usage_header_${isDark}'),
                        icon: LucideIcons.bookOpen,
                        title: 'How to Use',
                      ),
                      _UsageGuide(isDark: isDark),
                      const SizedBox(height: 24),

                      // Demo Section
                      SectionHeader(
                        key: ValueKey('demo_header_${isDark}'),
                        icon: LucideIcons.testTube,
                        title: 'Live Demo',
                      ),
                      _DemoSection(
                        viewModel: viewModel,
                        state: state,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),

                      // Box Info Section
                      if (state.boxInfo != null) ...[
                        SectionHeader(
                          key: ValueKey('info_header_${isDark}'),
                          icon: LucideIcons.database,
                          title: 'Box Information',
                        ),
                        _BoxInfoCard(
                          boxInfo: state.boxInfo!,
                          isDark: isDark,
                          onRefresh: () => viewModel.refreshBoxInfo(),
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
}

/// Usage guide widget
class _UsageGuide extends StatelessWidget {
  final bool isDark;

  const _UsageGuide({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UsageStep(
            number: 1,
            title: 'Initialize Hive',
            code: 'await Hive.initFlutter();',
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _UsageStep(
            number: 2,
            title: 'Open a Box',
            code: 'final box = await Hive.openBox(\'myBox\');',
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _UsageStep(
            number: 3,
            title: 'Save Data',
            code: 'await box.put(\'key\', value);',
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _UsageStep(
            number: 4,
            title: 'Read Data',
            code: 'final value = box.get(\'key\');',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _UsageStep extends StatelessWidget {
  final int number;
  final String title;
  final String code;
  final bool isDark;

  const _UsageStep({
    required this.number,
    required this.title,
    required this.code,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final codeBg = isDark ? AppColors.dark.codeBackground : AppColors.light.codeBackground;
    final codeText = isDark ? AppColors.dark.codeText : AppColors.light.codeText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: codeBg,
                  borderRadius: BorderRadius.circular(kRadius - 2),
                ),
                child: SelectableText(
                  code,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: codeText,
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

/// Demo section widget
class _DemoSection extends StatelessWidget {
  final HiveCeCubit viewModel;
  final HiveCeState state;
  final bool isDark;

  const _DemoSection({
    required this.viewModel,
    required this.state,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter item name',
                    hintStyle: TextStyle(color: textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                    ),
                  ),
                  style: TextStyle(color: textPrimary),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      viewModel.addItem(value.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add Item', style: TextStyle(color: textPrimary)),
                      content: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Item name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kRadius),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              viewModel.addItem(controller.text.trim());
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(LucideIcons.plus, color: context.primaryColor),
                tooltip: 'Add Item',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No items yet. Add some items to see them here!',
                  style: TextStyle(color: textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...state.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                title: Text(item, style: TextStyle(color: textPrimary)),
                trailing: IconButton(
                  icon: Icon(LucideIcons.trash2, color: AppColors.error, size: 18),
                  onPressed: () => viewModel.removeItem(index),
                  tooltip: 'Delete',
                ),
              );
            }),
          if (state.items.isNotEmpty) ...[
            const Divider(),
            TextButton.icon(
              onPressed: () => viewModel.clearAll(),
              icon: Icon(LucideIcons.trash2, size: 16),
              label: Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Box info card widget
class _BoxInfoCard extends StatelessWidget {
  final Map<String, dynamic> boxInfo;
  final bool isDark;
  final VoidCallback onRefresh;

  const _BoxInfoCard({
    required this.boxInfo,
    required this.isDark,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Box Statistics',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.refreshCw, size: 16),
                onPressed: onRefresh,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...boxInfo.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

