import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Security and privacy settings section
class SecuritySection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const SecuritySection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isBiometricAvailable = !kIsWeb;

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
          _BiometricTile(
            state: state,
            viewModel: viewModel,
            isAvailable: isBiometricAvailable,
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSwitchTile(
            title: 'PIN Lock',
            subtitle: 'Require PIN on app launch',
            value: state.pinLock,
            icon: LucideIcons.keyRound,
            onChanged: (_) => viewModel.togglePinLock(),
          ),
          Divider(height: 1, color: context.dividerColor),
          SettingSwitchTile(
            title: 'Auto Lock',
            subtitle: state.autoLock
                ? 'Lock after ${state.autoLockTimeout} minutes'
                : 'Disabled',
            value: state.autoLock,
            icon: LucideIcons.lock,
            onChanged: (_) => viewModel.toggleAutoLock(),
          ),
          if (state.autoLock) ...[
            Divider(height: 1, color: context.dividerColor),
            SettingSliderTile(
              title: 'Auto Lock Time',
              subtitle: '${state.autoLockTimeout} minutes',
              value: state.autoLockTimeout.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              icon: LucideIcons.timer,
              onChanged: (value) => viewModel.updateAutoLockTimeout(value.toInt()),
            ),
          ],
        ],
      ),
    );
  }
}

class _BiometricTile extends StatelessWidget {
  final SettingsState state;
  final SettingsCubit viewModel;
  final bool isAvailable;

  const _BiometricTile({
    required this.state,
    required this.viewModel,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.primaryColor;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isAvailable 
              ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
              : context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(
          LucideIcons.fingerprint,
          color: isAvailable ? primary : context.iconSecondaryColor,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              'Biometric Authentication',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isAvailable ? context.textPrimaryColor : context.textTertiaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isAvailable) ...[
            const SizedBox(width: 8),
            const Flexible(child: PlatformUnavailableBadge()),
          ],
        ],
      ),
      subtitle: Text(
        isAvailable
            ? 'Fingerprint / Face recognition'
            : 'This feature is only available on mobile/desktop apps',
        style: TextStyle(
          fontSize: 12,
          color: isAvailable ? context.textSecondaryColor : context.textTertiaryColor,
        ),
      ),
      trailing: Switch(
        value: state.biometricAuth && isAvailable,
        onChanged: isAvailable ? (_) => viewModel.toggleBiometricAuth() : null,
        activeColor: primary,
      ),
    );
  }
}
