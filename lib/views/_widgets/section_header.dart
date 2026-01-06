import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';

/// Reusable section header widget used across views
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final double? iconSize;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withValues(
                alpha: context.isDarkMode ? 0.2 : 0.1,
              ),
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(
              icon,
              size: iconSize ?? 18,
              color: primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
