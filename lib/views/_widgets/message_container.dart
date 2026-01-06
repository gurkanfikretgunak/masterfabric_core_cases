import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum MessageType { error, success, info, warning }

/// Reusable message container for showing status messages
class MessageContainer extends StatelessWidget {
  final String message;
  final MessageType type;
  final VoidCallback? onDismiss;

  const MessageContainer({
    super.key,
    required this.message,
    required this.type,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, iconColor, textColor, icon) = switch (type) {
      MessageType.error => (
          Colors.red.shade50,
          Colors.red.shade200,
          Colors.red.shade700,
          Colors.red.shade900,
          LucideIcons.circleAlert,
        ),
      MessageType.success => (
          Colors.green.shade50,
          Colors.green.shade200,
          Colors.green.shade700,
          Colors.green.shade900,
          LucideIcons.check,
        ),
      MessageType.info => (
          Colors.blue.shade50,
          Colors.blue.shade200,
          Colors.blue.shade700,
          Colors.blue.shade900,
          LucideIcons.info,
        ),
      MessageType.warning => (
          Colors.orange.shade50,
          Colors.orange.shade200,
          Colors.orange.shade700,
          Colors.orange.shade900,
          LucideIcons.triangleAlert,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 12),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(LucideIcons.x, size: 16),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

