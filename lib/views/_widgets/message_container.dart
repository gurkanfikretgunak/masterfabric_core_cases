import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

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
    final isDark = context.isDarkMode;
    
    final (color, icon) = switch (type) {
      MessageType.error => (AppColors.error, LucideIcons.circleAlert),
      MessageType.success => (AppColors.success, LucideIcons.check),
      MessageType.info => (AppColors.primary, LucideIcons.info),
      MessageType.warning => (AppColors.warning, LucideIcons.triangleAlert),
    };

    final bgColor = color.withValues(alpha: isDark ? 0.15 : 0.08);
    final borderColor = color.withValues(alpha: isDark ? 0.4 : 0.25);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.25 : 0.15),
              borderRadius: BorderRadius.circular(kRadius - 2),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? color : context.textPrimaryColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                LucideIcons.x,
                size: 16,
                color: context.iconSecondaryColor,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
