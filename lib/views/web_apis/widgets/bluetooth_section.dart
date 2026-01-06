import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_state.dart';

/// Bluetooth scanning section
class BluetoothSection extends StatelessWidget {
  final WebApisCubit viewModel;
  final WebApisState state;

  const BluetoothSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScanButton(state: state, viewModel: viewModel),
          if (state.scanError != null) ...[
            const SizedBox(height: 12),
            MessageContainer(
              message: state.scanError!,
              type: MessageType.error,
              onDismiss: viewModel.clearScanError,
            ),
          ],
          if (state.bluetoothDevices.isNotEmpty) ...[
            const SizedBox(height: 16),
            _DeviceListHeader(
              count: state.bluetoothDevices.length,
              onClear: viewModel.clearDevices,
            ),
            Divider(color: context.dividerColor),
            ...state.bluetoothDevices.map(
              (device) => _DeviceItem(
                device: device,
                viewModel: viewModel,
              ),
            ),
          ] else if (!state.isScanning) ...[
            const SizedBox(height: 16),
            const _EmptyState(),
          ],
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final WebApisState state;
  final WebApisCubit viewModel;

  const _ScanButton({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final enabled = state.bluetoothEnabled && !state.isScanning;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? viewModel.scanForDevices : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: enabled 
              ? AppColors.primary 
              : (isDark ? AppColors.dark.surfaceVariant : AppColors.light.surfaceVariant),
          foregroundColor: enabled 
              ? Colors.white 
              : context.textTertiaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.isScanning ? LucideIcons.loader : LucideIcons.search,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              state.isScanning ? 'Scanning...' : 'Scan for Devices',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceListHeader extends StatelessWidget {
  final int count;
  final VoidCallback onClear;

  const _DeviceListHeader({required this.count, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discovered Devices ($count)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: context.textPrimaryColor,
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: Icon(LucideIcons.trash2, size: 14, color: AppColors.error),
          label: Text(
            'Clear All',
            style: TextStyle(color: AppColors.error),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _DeviceItem extends StatelessWidget {
  final BluetoothDevice device;
  final WebApisCubit viewModel;

  const _DeviceItem({required this.device, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, HH:mm');
    final isDark = context.isDarkMode;
    final connectedColor = AppColors.success;
    final disconnectedColor = context.iconSecondaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: device.connected
                  ? connectedColor.withValues(alpha: isDark ? 0.2 : 0.15)
                  : context.cardSecondaryColor,
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(
              LucideIcons.bluetooth,
              color: device.connected ? connectedColor : disconnectedColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${device.id.length > 20 ? "${device.id.substring(0, 20)}..." : device.id}',
                  style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                ),
                Text(
                  'Last seen: ${dateFormat.format(device.lastSeen)}',
                  style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                ),
              ],
            ),
          ),
          if (device.connected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: connectedColor.withValues(alpha: isDark ? 0.2 : 0.15),
                borderRadius: BorderRadius.circular(kRadius - 2),
              ),
              child: Text(
                'Connected',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: connectedColor,
                ),
              ),
            ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: Icon(LucideIcons.ellipsisVertical, color: context.iconSecondaryColor, size: 18),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => device.connected
                    ? viewModel.disconnectDevice(device.id)
                    : viewModel.connectDevice(device.id),
                child: Row(
                  children: [
                    Icon(
                      device.connected ? LucideIcons.plugZap : LucideIcons.plug,
                      size: 16,
                      color: context.textPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      device.connected ? 'Disconnect' : 'Connect',
                      style: TextStyle(color: context.textPrimaryColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => viewModel.removeDevice(device.id),
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text('Remove', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(LucideIcons.bluetooth, size: 48, color: context.iconSecondaryColor),
          const SizedBox(height: 8),
          Text(
            'No devices found',
            style: TextStyle(
              color: context.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Click "Scan for Devices" to start',
            style: TextStyle(color: context.textTertiaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
