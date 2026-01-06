import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Reusable status chip for showing enabled/disabled states
class StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool showStatusIcon;

  const StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.enabled,
    this.showStatusIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.success : AppColors.error;
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            showStatusIcon ? '$label: ' : label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? color : color.withValues(alpha: 0.9),
            ),
          ),
          if (showStatusIcon)
            Icon(
              enabled ? LucideIcons.check : LucideIcons.x,
              size: 14,
              color: color,
            ),
        ],
      ),
    );
  }
}

/// Capability chip for showing feature availability
class CapabilityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAvailable;

  const CapabilityChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = isAvailable ? AppColors.success : (isDark ? Colors.grey.shade600 : Colors.grey.shade400);
    final textColor = isAvailable 
        ? (isDark ? AppColors.success : Colors.green.shade900)
        : context.textSecondaryColor;
    final bgColor = isAvailable 
        ? AppColors.success.withValues(alpha: isDark ? 0.15 : 0.08)
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade100);
    final borderColor = isAvailable
        ? AppColors.success.withValues(alpha: isDark ? 0.4 : 0.3)
        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
