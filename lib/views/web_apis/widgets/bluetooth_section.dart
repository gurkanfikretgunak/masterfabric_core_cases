import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              const Divider(),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: state.bluetoothEnabled && !state.isScanning
            ? viewModel.scanForDevices
            : null,
        icon: Icon(state.isScanning ? LucideIcons.loader : LucideIcons.search),
        label: Text(state.isScanning ? 'Scanning...' : 'Scan for Devices'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(LucideIcons.trash2, size: 14),
          label: const Text('Clear All'),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: device.connected
                ? Colors.green.shade100
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            LucideIcons.bluetooth,
            color:
                device.connected ? Colors.green.shade700 : Colors.grey.shade600,
            size: 24,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${device.id.length > 20 ? "${device.id.substring(0, 20)}..." : device.id}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              'Last seen: ${dateFormat.format(device.lastSeen)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (device.connected)
              Chip(
                label: const Text('Connected', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.green.shade100,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            const SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => device.connected
                      ? viewModel.disconnectDevice(device.id)
                      : viewModel.connectDevice(device.id),
                  child: Row(
                    children: [
                      Icon(
                        device.connected
                            ? LucideIcons.plugZap
                            : LucideIcons.plug,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(device.connected ? 'Disconnect' : 'Connect'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () => viewModel.removeDevice(device.id),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
          Icon(LucideIcons.bluetooth, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text('No devices found', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            'Click "Scan for Devices" to start',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

