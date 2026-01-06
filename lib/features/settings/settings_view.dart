import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/features/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';

/// Settings View - Demonstrates HydratedCubit for persistent state
class SettingsView
    extends MasterViewHydratedCubit<SettingsCubit, SettingsState> {
  SettingsView({super.key, required Function(String) goRoute})
    : super(
        currentView: MasterViewHydratedCubitTypes.content,
        goRoute: goRoute,
        arguments: const {'title': 'Settings'},
        coreAppBar: (context, viewModel) {
          return AppBar(
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => goRoute('/home'),
              tooltip: 'Back to Home',
            ),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.settings),
                SizedBox(width: 8),
                Text('Settings'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.rotateCcw),
                onPressed: () {
                  viewModel.resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(LucideIcons.check, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Settings reset'),
                        ],
                      ),
                    ),
                  );
                },
                tooltip: 'Reset to Defaults',
              ),
            ],
          );
        },
      );

  @override
  Future<void> initialContent(
    SettingsCubit viewModel,
    BuildContext context,
  ) async {
    debugPrint('Settings View Initialized with HydratedCubit');
    debugPrint('Persisted state loaded: ${viewModel.state}');
  }

  @override
  Widget viewContent(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: viewModel,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              _buildInfoCard(context),
              const SizedBox(height: 24),

              // Platform & Device Info Section
              _buildSectionHeader(
                context,
                LucideIcons.smartphone,
                'Platform & Device Info',
              ),
              _buildPlatformInfoSection(context),
              const SizedBox(height: 24),

              // Appearance Section
              _buildSectionHeader(context, LucideIcons.palette, 'Appearance'),
              _buildAppearanceSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Notifications Section
              _buildSectionHeader(context, LucideIcons.bell, 'Notifications'),
              _buildNotificationsSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader(
                context,
                LucideIcons.lock,
                'Security & Privacy',
              ),
              _buildSecuritySection(context, viewModel, state),
              const SizedBox(height: 24),

              // Sound & Haptics Section
              _buildSectionHeader(
                context,
                LucideIcons.volume2,
                'Sound & Haptics',
              ),
              _buildSoundSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Network Section
              _buildSectionHeader(context, LucideIcons.wifi, 'Network & Data'),
              _buildNetworkSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Profile Section
              _buildSectionHeader(
                context,
                LucideIcons.user,
                'Profile Information',
              ),
              _buildProfileSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Performance Section
              _buildSectionHeader(context, LucideIcons.zap, 'Performance'),
              _buildPerformanceSection(context, viewModel, state),
              const SizedBox(height: 32),

              // State Display
              _buildStateDisplay(context, state),
              const SizedBox(height: 16),

              // Raw Data Display
              _buildRawDataDisplay(context, viewModel, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(LucideIcons.info, color: Colors.blue.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Persistent Settings with HydratedCubit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All settings are automatically saved and restored when the app restarts.',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformInfoSection(BuildContext context) {
    // Get platform info using masterfabric_core helpers
    final deviceInfoHelper = DeviceInfoHelper.instance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Platform Detection
            FutureBuilder<String>(
              future: _getPlatformName(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.monitor,
                  'Platform',
                  snapshot.data ?? 'Loading...',
                  kIsWeb ? Colors.blue : Colors.green,
                );
              },
            ),
            const Divider(height: 20),

            // Device Name
            FutureBuilder<String>(
              future: deviceInfoHelper.platformDeviceDeviceName(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.smartphone,
                  'Device Name',
                  snapshot.data ?? 'Loading...',
                  Colors.purple,
                );
              },
            ),
            const Divider(height: 20),

            // Device Model
            FutureBuilder<String>(
              future: deviceInfoHelper.platformDeviceDeviceModel(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.cpu,
                  'Model',
                  snapshot.data ?? 'Loading...',
                  Colors.orange,
                );
              },
            ),
            const Divider(height: 20),

            // Manufacturer
            FutureBuilder<String>(
              future: deviceInfoHelper.platformDeviceDeviceFactory(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.factory,
                  'Manufacturer',
                  snapshot.data ?? 'Loading...',
                  Colors.red,
                );
              },
            ),
            const Divider(height: 20),

            // System Version
            FutureBuilder<List<String>>(
              future: deviceInfoHelper.platformDeviceSystemVersion(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.info,
                  'System Version',
                  snapshot.hasData ? snapshot.data!.join(' ') : 'Loading...',
                  Colors.cyan,
                );
              },
            ),
            const Divider(height: 20),

            // Device ID
            FutureBuilder<String>(
              future: deviceInfoHelper.platformDeviceDeviceID(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  LucideIcons.hash,
                  'Device ID',
                  snapshot.data != null && snapshot.data!.length > 20
                      ? '${snapshot.data!.substring(0, 20)}...'
                      : snapshot.data ?? 'Loading...',
                  Colors.teal,
                );
              },
            ),
            const Divider(height: 20),

            // App Version
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    _buildInfoRow(
                      LucideIcons.package,
                      'App Version',
                      snapshot.hasData ? snapshot.data!.version : 'Loading...',
                      Colors.indigo,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      LucideIcons.hash,
                      'Build Number',
                      snapshot.hasData
                          ? snapshot.data!.buildNumber
                          : 'Loading...',
                      Colors.pink,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      LucideIcons.fileText,
                      'App Name',
                      snapshot.hasData ? snapshot.data!.appName : 'Loading...',
                      Colors.amber,
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 20),

            // Physical Device
            FutureBuilder<bool>(
              future: deviceInfoHelper.platformDevicePhysical(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  snapshot.data == true
                      ? LucideIcons.smartphone
                      : LucideIcons.monitor,
                  'Device Type',
                  snapshot.data == true
                      ? 'Physical Device'
                      : 'Emulator/Simulator',
                  snapshot.data == true ? Colors.green : Colors.orange,
                );
              },
            ),

            // Platform-specific features
            const Divider(height: 20),
            _buildPlatformCapabilities(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformCapabilities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Features',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCapabilityChip(LucideIcons.globe, 'Web', kIsWeb),
            _buildCapabilityChip(
              LucideIcons.smartphone,
              'Mobile',
              !kIsWeb && (Platform.isAndroid || Platform.isIOS),
            ),
            _buildCapabilityChip(
              LucideIcons.monitor,
              'Desktop',
              !kIsWeb &&
                  (Platform.isMacOS || Platform.isWindows || Platform.isLinux),
            ),
            _buildCapabilityChip(
              LucideIcons.hardDrive,
              'Local Storage',
              true, // LocalStorageHelper available
            ),
            _buildCapabilityChip(
              LucideIcons.bell,
              'Push Notifications',
              !kIsWeb, // Available on native platforms
            ),
            _buildCapabilityChip(
              LucideIcons.fingerprint,
              'Biometric Auth',
              !kIsWeb, // Available on native platforms
            ),
            _buildCapabilityChip(
              LucideIcons.share2,
              'Native Share',
              true, // ApplicationShareHelper available
            ),
            _buildCapabilityChip(
              LucideIcons.download,
              'File Download',
              true, // FileDownloadHelper available
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCapabilityChip(IconData icon, String label, bool isAvailable) {
    return Chip(
      avatar: Icon(
        icon,
        size: 14,
        color: isAvailable ? Colors.green.shade700 : Colors.grey.shade400,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isAvailable ? Colors.green.shade900 : Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isAvailable
          ? Colors.green.shade50
          : Colors.grey.shade100,
      side: BorderSide(
        color: isAvailable ? Colors.green.shade300 : Colors.grey.shade300,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  Future<String> _getPlatformName() async {
    if (kIsWeb) {
      return 'Web Browser';
    }

    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isLinux) return 'Linux';
      if (Platform.isFuchsia) return 'Fuchsia';
    } catch (e) {
      return 'Unknown Platform';
    }

    return 'Unknown Platform';
  }

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: 'Dark Mode',
            subtitle: state.isDarkMode
                ? 'Dark theme active'
                : 'Light theme active',
            value: state.isDarkMode,
            icon: state.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
            onChanged: (value) => viewModel.toggleDarkMode(),
          ),
          const Divider(height: 1),
          _buildLanguageSelector(context, viewModel, state),
          const Divider(height: 1),
          _buildSliderTile(
            context: context,
            title: 'Font Size',
            subtitle: '${state.fontSize.toStringAsFixed(0)}px',
            value: state.fontSize,
            min: 10.0,
            max: 24.0,
            divisions: 14,
            icon: LucideIcons.type,
            onChanged: (value) => viewModel.updateFontSize(value),
          ),
          const Divider(height: 1),
          _buildColorSelector(context, viewModel, state, true),
          const Divider(height: 1),
          _buildColorSelector(context, viewModel, state, false),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    final bool isPushAvailable = !kIsWeb; // Push notifications only on native

    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: 'All Notifications',
            subtitle: state.notificationsEnabled
                ? 'Notifications enabled'
                : 'Notifications disabled',
            value: state.notificationsEnabled,
            icon: state.notificationsEnabled
                ? LucideIcons.bell
                : LucideIcons.bellOff,
            onChanged: (value) => viewModel.toggleNotifications(),
          ),
          if (state.notificationsEnabled) ...[
            const Divider(height: 1),
            _buildSwitchTile(
              context: context,
              title: 'Email Notifications',
              subtitle: 'Receive email notifications',
              value: state.emailNotifications,
              icon: LucideIcons.mail,
              onChanged: (value) => viewModel.toggleEmailNotifications(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                LucideIcons.smartphone,
                color: isPushAvailable
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Row(
                children: [
                  const Flexible(
                    child: Text(
                      'Push Notifications',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isPushAvailable) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
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
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                isPushAvailable
                    ? 'Receive instant notifications'
                    : 'This feature is only available on mobile/desktop apps',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              trailing: Switch(
                value: state.pushNotifications && isPushAvailable,
                onChanged: isPushAvailable
                    ? (value) => viewModel.togglePushNotifications()
                    : null,
              ),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              context: context,
              title: 'SMS Notifications',
              subtitle: 'Receive SMS notifications',
              value: state.smsNotifications,
              icon: LucideIcons.messageSquare,
              onChanged: (value) => viewModel.toggleSmsNotifications(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecuritySection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    final bool isBiometricAvailable =
        !kIsWeb; // Biometric only on native platforms

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              LucideIcons.fingerprint,
              color: isBiometricAvailable
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            title: Row(
              children: [
                const Flexible(
                  child: Text(
                    'Biometric Authentication',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isBiometricAvailable) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(
              isBiometricAvailable
                  ? 'Fingerprint / Face recognition'
                  : 'This feature is only available on mobile/desktop apps',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: Switch(
              value: state.biometricAuth && isBiometricAvailable,
              onChanged: isBiometricAvailable
                  ? (value) => viewModel.toggleBiometricAuth()
                  : null,
            ),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            context: context,
            title: 'PIN Lock',
            subtitle: 'Require PIN on app launch',
            value: state.pinLock,
            icon: LucideIcons.keyRound,
            onChanged: (value) => viewModel.togglePinLock(),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            context: context,
            title: 'Auto Lock',
            subtitle: state.autoLock
                ? 'Lock after ${state.autoLockTimeout} minutes'
                : 'Disabled',
            value: state.autoLock,
            icon: LucideIcons.lock,
            onChanged: (value) => viewModel.toggleAutoLock(),
          ),
          if (state.autoLock) ...[
            const Divider(height: 1),
            _buildSliderTile(
              context: context,
              title: 'Auto Lock Time',
              subtitle: '${state.autoLockTimeout} minutes',
              value: state.autoLockTimeout.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              icon: LucideIcons.timer,
              onChanged: (value) =>
                  viewModel.updateAutoLockTimeout(value.toInt()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoundSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    final bool isVibrationAvailable =
        !kIsWeb; // Vibration only on native mobile

    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: 'Sound Effects',
            subtitle: state.soundEffects ? 'Sound effects on' : 'Silent',
            value: state.soundEffects,
            icon: state.soundEffects
                ? LucideIcons.volume2
                : LucideIcons.volumeX,
            onChanged: (value) => viewModel.toggleSoundEffects(),
          ),
          if (state.soundEffects) ...[
            const Divider(height: 1),
            _buildSliderTile(
              context: context,
              title: 'Volume Level',
              subtitle: '${(state.volume * 100).toStringAsFixed(0)}%',
              value: state.volume,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              icon: LucideIcons.volume2,
              onChanged: (value) => viewModel.updateVolume(value),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.vibrate,
              color: isVibrationAvailable
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            title: Row(
              children: [
                const Text('Vibration'),
                if (!isVibrationAvailable) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
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
                  ),
                ],
              ],
            ),
            subtitle: Text(
              isVibrationAvailable
                  ? (state.vibration ? 'Vibration on' : 'Vibration off')
                  : 'This feature is only available on mobile devices',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: Switch(
              value: state.vibration && isVibrationAvailable,
              onChanged: isVibrationAvailable
                  ? (value) => viewModel.toggleVibration()
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: 'Wi-Fi Only Download',
            subtitle: 'Download without using mobile data',
            value: state.wifiOnlyDownload,
            icon: LucideIcons.wifi,
            onChanged: (value) => viewModel.toggleWifiOnlyDownload(),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            context: context,
            title: 'Auto Update',
            subtitle: 'Automatically download updates',
            value: state.autoDownloadUpdates,
            icon: LucideIcons.download,
            onChanged: (value) => viewModel.toggleAutoDownloadUpdates(),
          ),
          const Divider(height: 1),
          _buildSliderTile(
            context: context,
            title: 'Maximum Cache Size',
            subtitle: '${state.maxCacheSize.toStringAsFixed(0)} MB',
            value: state.maxCacheSize,
            min: 50,
            max: 500,
            divisions: 45,
            icon: LucideIcons.hardDrive,
            onChanged: (value) => viewModel.updateMaxCacheSize(value),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              LucideIcons.user,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('Username'),
            subtitle: Text(state.username),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.mail,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('Email'),
            subtitle: Text(state.email),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.image,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('Avatar'),
            subtitle: Text(
              state.avatarUrl.isEmpty ? 'No avatar selected' : 'Avatar set',
            ),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: 'Auto Save',
            subtitle: state.autoSave
                ? 'Changes are automatically saved'
                : 'Manual save',
            value: state.autoSave,
            icon: state.autoSave ? LucideIcons.save : LucideIcons.saveOff,
            onChanged: (value) => viewModel.toggleAutoSave(),
          ),
          const Divider(height: 1),
          _buildSliderTile(
            context: context,
            title: 'Animation Speed',
            subtitle: '${state.animationSpeed}x',
            value: state.animationSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            icon: LucideIcons.gauge,
            onChanged: (value) => viewModel.updateAnimationSpeed(value),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            context: context,
            title: 'Reduced Motion',
            subtitle: 'Reduce animations',
            value: state.reducedMotion,
            icon: LucideIcons.minimize2,
            onChanged: (value) => viewModel.toggleReducedMotion(),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            context: context,
            title: 'Data Compression',
            subtitle: 'Reduce data usage',
            value: state.dataCompression,
            icon: LucideIcons.archive,
            onChanged: (value) => viewModel.toggleDataCompression(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildSliderTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
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

  Widget _buildLanguageSelector(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return ExpansionTile(
      leading: Icon(LucideIcons.globe, color: Theme.of(context).primaryColor),
      title: const Text('Language'),
      subtitle: Text(_getLanguageName(state.language)),
      children: [
        RadioListTile<String>(
          title: const Text('Türkçe'),
          value: 'tr',
          groupValue: state.language,
          onChanged: (value) =>
              value != null ? viewModel.changeLanguage(value) : null,
        ),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: state.language,
          onChanged: (value) =>
              value != null ? viewModel.changeLanguage(value) : null,
        ),
        RadioListTile<String>(
          title: const Text('Deutsch'),
          value: 'de',
          groupValue: state.language,
          onChanged: (value) =>
              value != null ? viewModel.changeLanguage(value) : null,
        ),
        RadioListTile<String>(
          title: const Text('Français'),
          value: 'fr',
          groupValue: state.language,
          onChanged: (value) =>
              value != null ? viewModel.changeLanguage(value) : null,
        ),
      ],
    );
  }

  Widget _buildColorSelector(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
    bool isPrimary,
  ) {
    final colors = {
      'blue': Colors.blue,
      'red': Colors.red,
      'green': Colors.green,
      'purple': Colors.purple,
      'orange': Colors.orange,
    };

    final currentColor = isPrimary ? state.primaryColor : state.accentColor;

    return ExpansionTile(
      leading: Icon(LucideIcons.palette, color: Theme.of(context).primaryColor),
      title: Text(isPrimary ? 'Primary Color' : 'Accent Color'),
      subtitle: Text(_getColorName(currentColor)),
      children: colors.entries.map((entry) {
        return RadioListTile<String>(
          title: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(_getColorName(entry.key)),
            ],
          ),
          value: entry.key,
          groupValue: currentColor,
          onChanged: (value) {
            if (value != null) {
              if (isPrimary) {
                viewModel.changePrimaryColor(value);
              } else {
                viewModel.changeAccentColor(value);
              }
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildStateDisplay(BuildContext context, SettingsState state) {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.database, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Persisted State',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'These settings are automatically saved by HydratedCubit.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 12),
            _buildStatItem(
              LucideIcons.palette,
              'Theme',
              state.isDarkMode ? 'Dark' : 'Light',
            ),
            _buildStatItem(
              LucideIcons.globe,
              'Language',
              state.language.toUpperCase(),
            ),
            _buildStatItem(
              LucideIcons.type,
              'Font',
              '${state.fontSize.toStringAsFixed(0)}px',
            ),
            _buildStatItem(
              LucideIcons.bell,
              'Notifications',
              state.notificationsEnabled ? 'On' : 'Off',
            ),
            _buildStatItem(
              LucideIcons.lock,
              'Security',
              state.biometricAuth ? 'Biometric' : 'Standard',
            ),
            _buildStatItem(
              LucideIcons.volume2,
              'Volume',
              '${(state.volume * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRawDataDisplay(
    BuildContext context,
    SettingsCubit viewModel,
    SettingsState state,
  ) {
    return Card(
      color: Colors.orange.shade50,
      child: ExpansionTile(
        leading: Icon(LucideIcons.code, color: Colors.orange.shade700),
        title: Text(
          'Raw JSON Data (Stored Data)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
          ),
        ),
        subtitle: Text(
          'Raw data stored in HydratedBloc storage',
          style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.braces,
                      color: Colors.green.shade400,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Serialized State (JSON Format)',
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        LucideIcons.copy,
                        color: Colors.blue.shade300,
                        size: 18,
                      ),
                      onPressed: () {
                        // Copy to clipboard functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(LucideIcons.check, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text('JSON copied!'),
                              ],
                            ),
                          ),
                        );
                      },
                      tooltip: 'Copy',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: SelectableText(
                    _formatJson(state.toJson()),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.green.shade300,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      color: Colors.blue.shade400,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This data is stored unencrypted on the device by HydratedBloc.',
                        style: TextStyle(
                          color: Colors.blue.shade300,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildDataChip(
                      LucideIcons.fileJson,
                      'Total Keys: ${state.toJson().keys.length}',
                      Colors.purple,
                    ),
                    _buildDataChip(
                      LucideIcons.hardDrive,
                      'Storage: ${_calculateStorageSize(state.toJson())} bytes',
                      Colors.cyan,
                    ),
                    _buildDataChip(
                      LucideIcons.clock,
                      'Auto-saved',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataChip(IconData icon, String label, MaterialColor color) {
    return Chip(
      avatar: Icon(icon, size: 14, color: color.shade100),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color.shade100,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  String _formatJson(Map<String, dynamic> json) {
    final buffer = StringBuffer();
    buffer.writeln('{');

    final entries = json.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isLast = i == entries.length - 1;

      buffer.write('  "${entry.key}": ');

      if (entry.value is String) {
        buffer.write('"${entry.value}"');
      } else if (entry.value is num) {
        buffer.write(entry.value);
      } else if (entry.value is bool) {
        buffer.write(entry.value);
      } else {
        buffer.write(entry.value);
      }

      if (!isLast) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
      }
    }

    buffer.write('}');
    return buffer.toString();
  }

  int _calculateStorageSize(Map<String, dynamic> json) {
    return json.toString().length;
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      default:
        return code;
    }
  }

  String _getColorName(String color) {
    switch (color) {
      case 'blue':
        return 'Blue';
      case 'red':
        return 'Red';
      case 'green':
        return 'Green';
      case 'purple':
        return 'Purple';
      case 'orange':
        return 'Orange';
      default:
        return color;
    }
  }
}
