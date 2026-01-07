import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Notifications settings section
class NotificationsSection extends StatelessWidget {
  final SettingsCubit viewModel;
  final SettingsState state;

  const NotificationsSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isPushAvailable = !kIsWeb;

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
          SettingSwitchTile(
            title: 'All Notifications',
            subtitle: state.notificationsEnabled
                ? 'Notifications enabled'
                : 'Notifications disabled',
            value: state.notificationsEnabled,
            icon: state.notificationsEnabled
                ? LucideIcons.bell
                : LucideIcons.bellOff,
            onChanged: (_) => viewModel.toggleNotifications(),
          ),
          if (state.notificationsEnabled) ...[
            Divider(height: 1, color: context.dividerColor),
            SettingSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive email notifications',
              value: state.emailNotifications,
              icon: LucideIcons.mail,
              onChanged: (_) => viewModel.toggleEmailNotifications(),
            ),
            Divider(height: 1, color: context.dividerColor),
            _PushNotificationTile(
              state: state,
              viewModel: viewModel,
              isAvailable: isPushAvailable,
            ),
            Divider(height: 1, color: context.dividerColor),
            SettingSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive SMS notifications',
              value: state.smsNotifications,
              icon: LucideIcons.messageSquare,
              onChanged: (_) => viewModel.toggleSmsNotifications(),
            ),
          ],
        ],
      ),
    );
  }
}

class _PushNotificationTile extends StatelessWidget {
  final SettingsState state;
  final SettingsCubit viewModel;
  final bool isAvailable;

  const _PushNotificationTile({
    required this.state,
    required this.viewModel,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.primaryColor;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isAvailable 
              ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
              : context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Icon(
          LucideIcons.smartphone,
          color: isAvailable ? primary : context.iconSecondaryColor,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              'Push Notifications',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isAvailable ? context.textPrimaryColor : context.textTertiaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isAvailable) ...[
            const SizedBox(width: 8),
            const Flexible(child: PlatformUnavailableBadge()),
          ],
        ],
      ),
      subtitle: Text(
        isAvailable
            ? 'Receive instant notifications'
            : 'This feature is only available on mobile/desktop apps',
        style: TextStyle(
          fontSize: 12,
          color: isAvailable ? context.textSecondaryColor : context.textTertiaryColor,
        ),
      ),
      trailing: Switch(
        value: state.pushNotifications && isAvailable,
        onChanged: isAvailable ? (_) => viewModel.togglePushNotifications() : null,
        activeColor: primary,
      ),
    );
  }
}
