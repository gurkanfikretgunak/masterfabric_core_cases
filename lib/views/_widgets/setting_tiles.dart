import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Reusable switch tile for settings
class SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const SettingSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.primaryColor;
    
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? context.textPrimaryColor : context.textTertiaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: enabled ? context.textSecondaryColor : context.textTertiaryColor,
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled 
              ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
              : context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(
          icon,
          color: enabled ? primary : context.iconSecondaryColor,
          size: 20,
        ),
      ),
      activeColor: primary,
    );
  }
}

/// Reusable slider tile for settings
class SettingSliderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const SettingSliderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.primaryColor;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(icon, color: primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: context.textSecondaryColor,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: primary,
              inactiveTrackColor: primary.withValues(alpha: isDark ? 0.3 : 0.2),
              thumbColor: primary,
              overlayColor: primary.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: subtitle,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Platform unavailable badge widget
class PlatformUnavailableBadge extends StatelessWidget {
  const PlatformUnavailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: isDark ? 0.4 : 0.3),
        ),
      ),
      child: Text(
        'Not Available on Web',
        style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColors.warning : Colors.orange.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
