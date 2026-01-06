import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    final color = enabled ? Colors.green : Colors.red;

    return Chip(
      avatar: Icon(icon, size: 16, color: color.shade700),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            showStatusIcon ? '$label: ' : label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
          if (showStatusIcon)
            Icon(
              enabled ? LucideIcons.check : LucideIcons.x,
              size: 12,
              color: color.shade900,
            ),
        ],
      ),
      backgroundColor: color.shade50,
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
    return Chip(
      avatar: Icon(
        icon,
        size: 14,
        color: isAvailable ? Colors.green.shade700 : Colors.grey.shade400,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isAvailable ? Colors.green.shade900 : Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor:
          isAvailable ? Colors.green.shade50 : Colors.grey.shade100,
      side: BorderSide(
        color: isAvailable ? Colors.green.shade300 : Colors.grey.shade300,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

