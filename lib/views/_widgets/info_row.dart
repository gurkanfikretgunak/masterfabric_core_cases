import 'package:flutter/material.dart';

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
    return Row(
      children: [
        if (showContainer)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          )
        else
          Icon(icon, color: color, size: 18),
        SizedBox(width: showContainer ? 12 : 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: showContainer ? null : color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

