import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Profile information settings section
class ProfileSection extends StatelessWidget {
  final SettingsState state;

  const ProfileSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _ProfileTile(
            icon: LucideIcons.user,
            title: 'Username',
            subtitle: state.username,
          ),
          const Divider(height: 1),
          _ProfileTile(
            icon: LucideIcons.mail,
            title: 'Email',
            subtitle: state.email,
          ),
          const Divider(height: 1),
          _ProfileTile(
            icon: LucideIcons.image,
            title: 'Avatar',
            subtitle:
                state.avatarUrl.isEmpty ? 'No avatar selected' : 'Avatar set',
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(LucideIcons.chevronRight),
      onTap: () {},
    );
  }
}

