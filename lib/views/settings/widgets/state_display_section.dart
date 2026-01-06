import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// State display section showing persisted state summary
class StateDisplaySection extends StatelessWidget {
  final SettingsState state;

  const StateDisplaySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.database, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Persisted State',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'These settings are automatically saved by HydratedCubit.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 12),
            _StatItem(
              icon: LucideIcons.palette,
              label: 'Theme',
              value: state.isDarkMode ? 'Dark' : 'Light',
            ),
            _StatItem(
              icon: LucideIcons.globe,
              label: 'Language',
              value: state.language.toUpperCase(),
            ),
            _StatItem(
              icon: LucideIcons.type,
              label: 'Font',
              value: '${state.fontSize.toStringAsFixed(0)}px',
            ),
            _StatItem(
              icon: LucideIcons.bell,
              label: 'Notifications',
              value: state.notificationsEnabled ? 'On' : 'Off',
            ),
            _StatItem(
              icon: LucideIcons.lock,
              label: 'Security',
              value: state.biometricAuth ? 'Biometric' : 'Standard',
            ),
            _StatItem(
              icon: LucideIcons.volume2,
              label: 'Volume',
              value: '${(state.volume * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

