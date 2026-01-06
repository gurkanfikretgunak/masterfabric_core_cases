import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

    return Card(
      child: Column(
        children: [
          _BiometricTile(
            state: state,
            viewModel: viewModel,
            isAvailable: isBiometricAvailable,
          ),
          const Divider(height: 1),
          SettingSwitchTile(
            title: 'PIN Lock',
            subtitle: 'Require PIN on app launch',
            value: state.pinLock,
            icon: LucideIcons.keyRound,
            onChanged: (_) => viewModel.togglePinLock(),
          ),
          const Divider(height: 1),
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
            const Divider(height: 1),
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
    return ListTile(
      leading: Icon(
        LucideIcons.fingerprint,
        color: isAvailable ? Theme.of(context).primaryColor : Colors.grey,
      ),
      title: Row(
        children: [
          const Flexible(
            child: Text(
              'Biometric Authentication',
              overflow: TextOverflow.ellipsis,
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
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: state.biometricAuth && isAvailable,
        onChanged: isAvailable ? (_) => viewModel.toggleBiometricAuth() : null,
      ),
    );
  }
}

