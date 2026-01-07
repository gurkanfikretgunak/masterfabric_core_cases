import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// State display section showing persisted state summary
class StateDisplaySection extends StatelessWidget {
  final SettingsState state;

  const StateDisplaySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                child: Icon(
                  LucideIcons.database,
                  color: context.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Persisted State',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.textPrimaryColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'These settings are automatically saved by HydratedCubit.',
            style: TextStyle(
              color: context.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.iconSecondaryColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: context.textSecondaryColor,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: context.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
