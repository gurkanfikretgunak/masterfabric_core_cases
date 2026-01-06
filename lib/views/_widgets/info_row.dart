import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Reusable info row widget for displaying label-value pairs with icons
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool showContainer;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.showContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Row(
      children: [
        if (showContainer)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(icon, color: color, size: 20),
          )
        else
          Icon(icon, color: color, size: 18),
        SizedBox(width: showContainer ? 14 : 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: showContainer ? context.textPrimaryColor : color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
