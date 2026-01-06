import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Network and data settings section
class NetworkSection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const NetworkSection({
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
            title: 'Wi-Fi Only Download',
            subtitle: 'Download without using mobile data',
            value: state.wifiOnlyDownload,
            icon: LucideIcons.wifi,
            onChanged: (_) => viewModel.toggleWifiOnlyDownload(),
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSwitchTile(
            title: 'Auto Update',
            subtitle: 'Automatically download updates',
            value: state.autoDownloadUpdates,
            icon: LucideIcons.download,
            onChanged: (_) => viewModel.toggleAutoDownloadUpdates(),
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSliderTile(
            title: 'Maximum Cache Size',
            subtitle: '${state.maxCacheSize.toStringAsFixed(0)} MB',
            value: state.maxCacheSize,
            min: 50,
            max: 500,
            divisions: 45,
            icon: LucideIcons.hardDrive,
            onChanged: viewModel.updateMaxCacheSize,
          ),
        ],
      ),
    );
  }
}
