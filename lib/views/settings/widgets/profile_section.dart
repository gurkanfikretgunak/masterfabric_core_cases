import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Profile information settings section
class ProfileSection extends StatelessWidget {
  final SettingsState state;

  const ProfileSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileTile(
            icon: LucideIcons.user,
            title: 'Username',
            subtitle: state.username,
          ),
          Divider(height: 1, color: context.dividerColor),
          _ProfileTile(
            icon: LucideIcons.mail,
            title: 'Email',
            subtitle: state.email,
          ),
          Divider(height: 1, color: context.dividerColor),
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
    final isDark = context.isDarkMode;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: context.textSecondaryColor,
        ),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: context.iconSecondaryColor,
        size: 20,
      ),
      onTap: () {},
    );
  }
}
