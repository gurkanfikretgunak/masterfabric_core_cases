import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

    return Card(
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
            const Divider(height: 1),
            SettingSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive email notifications',
              value: state.emailNotifications,
              icon: LucideIcons.mail,
              onChanged: (_) => viewModel.toggleEmailNotifications(),
            ),
            const Divider(height: 1),
            _PushNotificationTile(
              state: state,
              viewModel: viewModel,
              isAvailable: isPushAvailable,
            ),
            const Divider(height: 1),
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
    return ListTile(
      leading: Icon(
        LucideIcons.smartphone,
        color: isAvailable ? Theme.of(context).primaryColor : Colors.grey,
      ),
      title: Row(
        children: [
          const Flexible(
            child: Text('Push Notifications', overflow: TextOverflow.ellipsis),
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
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: state.pushNotifications && isAvailable,
        onChanged:
            isAvailable ? (_) => viewModel.togglePushNotifications() : null,
      ),
    );
  }
}

