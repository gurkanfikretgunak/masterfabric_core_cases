import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Performance settings section
class PerformanceSection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const PerformanceSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          SettingSwitchTile(
            title: 'Auto Save',
            subtitle: state.autoSave
                ? 'Changes are automatically saved'
                : 'Manual save',
            value: state.autoSave,
            icon: state.autoSave ? LucideIcons.save : LucideIcons.saveOff,
            onChanged: (_) => viewModel.toggleAutoSave(),
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSliderTile(
            title: 'Animation Speed',
            subtitle: '${state.animationSpeed}x',
            value: state.animationSpeed,
            min: 0.5,
            max: 2,
            divisions: 15,
            icon: LucideIcons.gauge,
            onChanged: viewModel.updateAnimationSpeed,
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSwitchTile(
            title: 'Reduced Motion',
            subtitle: 'Reduce animations',
            value: state.reducedMotion,
            icon: LucideIcons.minimize2,
            onChanged: (_) => viewModel.toggleReducedMotion(),
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSwitchTile(
            title: 'Data Compression',
            subtitle: 'Reduce data usage',
            value: state.dataCompression,
            icon: LucideIcons.archive,
            onChanged: (_) => viewModel.toggleDataCompression(),
          ),
        ],
      ),
    );
  }
}
