import 'package:flutter/material.dart';

/// Reusable switch tile for settings
class SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const SettingSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      secondary: Icon(
        icon,
        color: enabled ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}

/// Reusable slider tile for settings
class SettingSliderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const SettingSliderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: subtitle,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Platform unavailable badge widget
class PlatformUnavailableBadge extends StatelessWidget {
  const PlatformUnavailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Not Available on Web',
        style: TextStyle(
          fontSize: 10,
          color: Colors.orange.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

