import 'package:flutter/material.dart';

/// Reusable info card widget for displaying highlighted information
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? descriptionColor;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.descriptionColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.blue.shade50;
    final iColor = iconColor ?? Colors.blue.shade700;
    final tColor = titleColor ?? Colors.blue.shade900;
    final dColor = descriptionColor ?? Colors.blue.shade700;

    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: dColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

