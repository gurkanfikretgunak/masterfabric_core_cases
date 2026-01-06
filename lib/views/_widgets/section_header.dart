import 'package:flutter/material.dart';

/// Reusable section header widget used across views
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final double? iconSize;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: iconSize ?? 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

