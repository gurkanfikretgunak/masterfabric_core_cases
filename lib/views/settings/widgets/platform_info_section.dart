import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';

/// Platform and device information section
class PlatformInfoSection extends StatelessWidget {
  const PlatformInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceInfoHelper = DeviceInfoHelper.instance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlatformRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            _DeviceNameRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            _DeviceModelRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            _ManufacturerRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            _SystemVersionRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            _DeviceIdRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            const _AppInfoSection(),
            const Divider(height: 20),
            _DeviceTypeRow(deviceInfoHelper: deviceInfoHelper),
            const Divider(height: 20),
            const _PlatformCapabilities(),
          ],
        ),
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _PlatformRow({required this.deviceInfoHelper});

  Future<String> _getPlatformName() async {
    if (kIsWeb) return 'Web Browser';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getPlatformName(),
      builder: (context, snapshot) => InfoRow(
        icon: LucideIcons.monitor,
        label: 'Platform',
        value: snapshot.data ?? 'Loading...',
        color: kIsWeb ? Colors.blue : Colors.green,
      ),
    );
  }
}

class _DeviceNameRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _DeviceNameRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: deviceInfoHelper.platformDeviceDeviceName(),
      builder: (context, snapshot) => InfoRow(
        icon: LucideIcons.smartphone,
        label: 'Device Name',
        value: snapshot.data ?? 'Loading...',
        color: Colors.purple,
      ),
    );
  }
}

class _DeviceModelRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _DeviceModelRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: deviceInfoHelper.platformDeviceDeviceModel(),
      builder: (context, snapshot) => InfoRow(
        icon: LucideIcons.cpu,
        label: 'Model',
        value: snapshot.data ?? 'Loading...',
        color: Colors.orange,
      ),
    );
  }
}

class _ManufacturerRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _ManufacturerRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: deviceInfoHelper.platformDeviceDeviceFactory(),
      builder: (context, snapshot) => InfoRow(
        icon: LucideIcons.factory,
        label: 'Manufacturer',
        value: snapshot.data ?? 'Loading...',
        color: Colors.red,
      ),
    );
  }
}

class _SystemVersionRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _SystemVersionRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: deviceInfoHelper.platformDeviceSystemVersion(),
      builder: (context, snapshot) => InfoRow(
        icon: LucideIcons.info,
        label: 'System Version',
        value: snapshot.hasData ? snapshot.data!.join(' ') : 'Loading...',
        color: Colors.cyan,
      ),
    );
  }
}

class _DeviceIdRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _DeviceIdRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: deviceInfoHelper.platformDeviceDeviceID(),
      builder: (context, snapshot) {
        final value = snapshot.data;
        final displayValue = value != null && value.length > 20
            ? '${value.substring(0, 20)}...'
            : value ?? 'Loading...';
        return InfoRow(
          icon: LucideIcons.hash,
          label: 'Device ID',
          value: displayValue,
          color: Colors.teal,
        );
      },
    );
  }
}

class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        return Column(
          children: [
            InfoRow(
              icon: LucideIcons.package,
              label: 'App Version',
              value: snapshot.hasData ? snapshot.data!.version : 'Loading...',
              color: Colors.indigo,
            ),
            const Divider(height: 20),
            InfoRow(
              icon: LucideIcons.hash,
              label: 'Build Number',
              value:
                  snapshot.hasData ? snapshot.data!.buildNumber : 'Loading...',
              color: Colors.pink,
            ),
            const Divider(height: 20),
            InfoRow(
              icon: LucideIcons.fileText,
              label: 'App Name',
              value: snapshot.hasData ? snapshot.data!.appName : 'Loading...',
              color: Colors.amber,
            ),
          ],
        );
      },
    );
  }
}

class _DeviceTypeRow extends StatelessWidget {
  final DeviceInfoHelper deviceInfoHelper;

  const _DeviceTypeRow({required this.deviceInfoHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: deviceInfoHelper.platformDevicePhysical(),
      builder: (context, snapshot) {
        final isPhysical = snapshot.data == true;
        return InfoRow(
          icon: isPhysical ? LucideIcons.smartphone : LucideIcons.monitor,
          label: 'Device Type',
          value: isPhysical ? 'Physical Device' : 'Emulator/Simulator',
          color: isPhysical ? Colors.green : Colors.orange,
        );
      },
    );
  }
}

class _PlatformCapabilities extends StatelessWidget {
  const _PlatformCapabilities();

  bool get _isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  bool get _isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  @override
  Widget build(BuildContext context) {
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
            CapabilityChip(
              icon: LucideIcons.globe,
              label: 'Web',
              isAvailable: kIsWeb,
            ),
            CapabilityChip(
              icon: LucideIcons.smartphone,
              label: 'Mobile',
              isAvailable: _isMobile,
            ),
            CapabilityChip(
              icon: LucideIcons.monitor,
              label: 'Desktop',
              isAvailable: _isDesktop,
            ),
            const CapabilityChip(
              icon: LucideIcons.hardDrive,
              label: 'Local Storage',
              isAvailable: true,
            ),
            CapabilityChip(
              icon: LucideIcons.bell,
              label: 'Push Notifications',
              isAvailable: !kIsWeb,
            ),
            CapabilityChip(
              icon: LucideIcons.fingerprint,
              label: 'Biometric Auth',
              isAvailable: !kIsWeb,
            ),
            const CapabilityChip(
              icon: LucideIcons.share2,
              label: 'Native Share',
              isAvailable: true,
            ),
            const CapabilityChip(
              icon: LucideIcons.download,
              label: 'File Download',
              isAvailable: true,
            ),
          ],
        ),
      ],
    );
  }
}

