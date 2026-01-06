import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Sound and haptics settings section
class SoundSection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const SoundSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isVibrationAvailable = !kIsWeb;

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
            title: 'Sound Effects',
            subtitle: state.soundEffects ? 'Sound effects on' : 'Silent',
            value: state.soundEffects,
            icon:
                state.soundEffects ? LucideIcons.volume2 : LucideIcons.volumeX,
            onChanged: (_) => viewModel.toggleSoundEffects(),
          ),
          if (state.soundEffects) ...[
            Divider(height: 1, color: context.dividerColor),
            SettingSliderTile(
              title: 'Volume Level',
              subtitle: '${(state.volume * 100).toStringAsFixed(0)}%',
              value: state.volume,
              min: 0,
              max: 1,
              divisions: 20,
              icon: LucideIcons.volume2,
              onChanged: viewModel.updateVolume,
            ),
          ],
          Divider(height: 1, color: context.dividerColor),
          _VibrationTile(
            state: state,
            viewModel: viewModel,
            isAvailable: isVibrationAvailable,
          ),
        ],
      ),
    );
  }
}

class _VibrationTile extends StatelessWidget {
  final SettingsState state;
  final SettingsCubit viewModel;
  final bool isAvailable;

  const _VibrationTile({
    required this.state,
    required this.viewModel,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isAvailable 
              ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1)
              : context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(
          LucideIcons.vibrate,
          color: isAvailable ? AppColors.primary : context.iconSecondaryColor,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            'Vibration',
            style: TextStyle(
              color: isAvailable ? context.textPrimaryColor : context.textTertiaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isAvailable) ...[
            const SizedBox(width: 8),
            const PlatformUnavailableBadge(),
          ],
        ],
      ),
      subtitle: Text(
        isAvailable
            ? (state.vibration ? 'Vibration on' : 'Vibration off')
            : 'This feature is only available on mobile devices',
        style: TextStyle(
          fontSize: 12,
          color: isAvailable ? context.textSecondaryColor : context.textTertiaryColor,
        ),
      ),
      trailing: Switch(
        value: state.vibration && isAvailable,
        onChanged: isAvailable ? (_) => viewModel.toggleVibration() : null,
        activeColor: AppColors.primary,
      ),
    );
  }
}
