import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Reusable info card widget for displaying highlighted information
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? accentColor;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.accentColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? context.primaryColor;
    final bgColor = context.isDarkMode 
        ? color.withValues(alpha: 0.15) 
        : color.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: color.withValues(alpha: context.isDarkMode ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          ThemedWidgets.iconBox(
            context: context,
            icon: icon,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
            size: 44,
            iconSize: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: context.textSecondaryColor,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
