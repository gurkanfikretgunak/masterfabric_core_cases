import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_state.dart';
import 'package:intl/intl.dart';

/// Web APIs View - Demonstrates Bluetooth and Passkey Web APIs
class WebApisView extends MasterViewHydratedCubit<WebApisCubit, WebApisState> {
  WebApisView({super.key, required Function(String) goRoute})
    : super(
        currentView: MasterViewHydratedCubitTypes.content,
        goRoute: goRoute,
        arguments: const {'title': 'Web APIs'},
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
                Icon(LucideIcons.radio),
                SizedBox(width: 8),
                Text('Web APIs Demo'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.info),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(LucideIcons.info),
                          SizedBox(width: 8),
                          Text('Web APIs Info'),
                        ],
                      ),
                      content: const Text(
                        'This feature demonstrates Chrome Web APIs:\n\n'
                        '• Web Bluetooth API for device scanning\n'
                        '• WebAuthn API for passkey authentication\n\n'
                        'Note: These APIs only work in Chrome/Edge browsers with HTTPS.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
                tooltip: 'Info',
              ),
            ],
          );
        },
      );
  @override
  Future<void> initialContent(
    WebApisCubit viewModel,
    BuildContext context,
  ) async {
    debugPrint('Web APIs View Initialized');
    // Recheck API support after state restoration
    viewModel.recheckApiSupport();
  }

  @override
  Widget viewContent(
    BuildContext context,
    WebApisCubit viewModel,
    WebApisState state,
  ) {
    return BlocBuilder<WebApisCubit, WebApisState>(
      bloc: viewModel,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              _buildInfoCard(context, state),
              const SizedBox(height: 24),

              // Bluetooth Section
              _buildSectionHeader(
                context,
                LucideIcons.bluetooth,
                'Web Bluetooth API',
              ),
              _buildBluetoothSection(context, viewModel, state),
              const SizedBox(height: 24),

              // Passkey Section
              _buildSectionHeader(
                context,
                LucideIcons.key,
                'WebAuthn (Passkeys)',
              ),
              _buildPasskeySection(context, viewModel, state),
              const SizedBox(height: 32),

              // Raw State Display
              _buildRawStateDisplay(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context, WebApisState state) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(LucideIcons.chrome, color: Colors.blue.shade700, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chrome Web APIs',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bluetooth scanning & passwordless authentication (macOS Touch ID supported)',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusChip(
                  LucideIcons.bluetooth,
                  'Bluetooth',
                  state.bluetoothEnabled,
                ),
                _buildStatusChip(
                  LucideIcons.key,
                  'Passkeys',
                  state.passkeyEnabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String label, bool enabled) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: enabled ? Colors.green.shade700 : Colors.red.shade700,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: enabled ? Colors.green.shade900 : Colors.red.shade900,
            ),
          ),
          Icon(
            enabled ? LucideIcons.check : LucideIcons.x,
            size: 12,
            color: enabled ? Colors.green.shade900 : Colors.red.shade900,
          ),
        ],
      ),
      backgroundColor: enabled ? Colors.green.shade50 : Colors.red.shade50,
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBluetoothSection(
    BuildContext context,
    WebApisCubit viewModel,
    WebApisState state,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.bluetoothEnabled && !state.isScanning
                    ? () => viewModel.scanForDevices()
                    : null,
                icon: Icon(
                  state.isScanning ? LucideIcons.loader : LucideIcons.search,
                ),
                label: Text(
                  state.isScanning ? 'Scanning...' : 'Scan for Devices',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // Error Message
            if (state.scanError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      color: Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.scanError!,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 16),
                      onPressed: () => viewModel.clearScanError(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],

            // Device List
            if (state.bluetoothDevices.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discovered Devices (${state.bluetoothDevices.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => viewModel.clearDevices(),
                    icon: const Icon(LucideIcons.trash2, size: 14),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const Divider(),
              ...state.bluetoothDevices.map(
                (device) => _buildDeviceItem(context, viewModel, device),
              ),
            ] else if (!state.isScanning) ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.bluetooth,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No devices found',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click "Scan for Devices" to start',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(
    BuildContext context,
    WebApisCubit viewModel,
    BluetoothDevice device,
  ) {
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
            color: device.connected
                ? Colors.green.shade700
                : Colors.grey.shade600,
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
              )
            else
              const SizedBox.shrink(),
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

  Widget _buildPasskeySection(
    BuildContext context,
    WebApisCubit viewModel,
    WebApisState state,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create Passkey Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.passkeyEnabled && !state.isAuthenticating
                    ? () => _showCreatePasskeyDialog(context, viewModel)
                    : null,
                icon: const Icon(LucideIcons.keyRound),
                label: const Text('Create New Passkey'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Authenticate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.passkeyEnabled && !state.isAuthenticating
                    ? () => _authenticateWithAlert(context, viewModel)
                    : null,
                icon: Icon(
                  state.isAuthenticating
                      ? LucideIcons.loader
                      : LucideIcons.lockOpen,
                ),
                label: Text(
                  state.isAuthenticating
                      ? 'Authenticating...'
                      : 'Authenticate with Passkey',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // Last Successful Auth
            if (state.lastSuccessfulAuth != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.check,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Last authenticated: ${state.lastSuccessfulAuth}',
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Error Message
            if (state.authError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      color: Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.authError!,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 16),
                      onPressed: () => viewModel.clearAuthError(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],

            // Passkey List
            if (state.passkeys.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stored Passkeys (${state.passkeys.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => viewModel.clearPasskeys(),
                    icon: const Icon(LucideIcons.trash2, size: 14),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const Divider(),
              ...state.passkeys.map(
                (passkey) => _buildPasskeyItem(context, viewModel, passkey),
              ),
            ] else if (!state.isAuthenticating) ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.key,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No passkeys stored',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a passkey to get started',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasskeyItem(
    BuildContext context,
    WebApisCubit viewModel,
    PasskeyCredential passkey,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(LucideIcons.key, color: Colors.purple.shade700, size: 24),
        ),
        title: Text(
          passkey.displayName ?? passkey.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${passkey.username}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              'Created: ${dateFormat.format(passkey.createdAt)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              'Last used: ${dateFormat.format(passkey.lastUsed)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.red),
          onPressed: () => viewModel.removePasskey(passkey.id),
          tooltip: 'Remove passkey',
        ),
      ),
    );
  }

  void _showCreatePasskeyDialog(BuildContext context, WebApisCubit viewModel) {
    final usernameController = TextEditingController();
    final displayNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(LucideIcons.keyRound),
            SizedBox(width: 8),
            Text('Create Passkey'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
                prefixIcon: Icon(LucideIcons.user),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name (Optional)',
                hintText: 'Enter display name',
                prefixIcon: Icon(LucideIcons.userRound),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.trim().isNotEmpty) {
                Navigator.pop(context);

                // Show platform authentication alert
                await _showPlatformAuthAlert(context);

                // Create the passkey
                await viewModel.createPasskey(
                  username: usernameController.text.trim(),
                  displayName: displayNameController.text.trim().isEmpty
                      ? null
                      : displayNameController.text.trim(),
                );

                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text('Passkey created successfully!'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Show platform authentication alert dialog
  Future<void> _showPlatformAuthAlert(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(LucideIcons.fingerprint, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Platform Authentication'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlatformAuthInfo(),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Simulating platform authentication...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );

    // Auto-close after a delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  /// Show authentication with platform-specific alert
  Future<void> _authenticateWithAlert(
    BuildContext context,
    WebApisCubit viewModel,
  ) async {
    // Show platform-specific info dialog
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(LucideIcons.fingerprint, color: Colors.green),
            SizedBox(width: 8),
            Text('Authenticate with Passkey'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will trigger platform authentication:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPlatformAuthInfo(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.info, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This is a demo. In production, you would authenticate with your saved passkey.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(LucideIcons.fingerprint),
            label: const Text('Authenticate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (shouldContinue == true) {
      await viewModel.authenticateWithPasskey();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.check, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Flexible(child: Text('Authentication successful!')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Build platform-specific authentication info
  Widget _buildPlatformAuthInfo() {
    String platform;
    IconData icon;
    Color color;

    try {
      if (kIsWeb) {
        platform = 'Browser passkey dialog';
        icon = LucideIcons.globe;
        color = Colors.blue;
      } else if (Platform.isMacOS) {
        platform = 'macOS Touch ID / Keychain';
        icon = LucideIcons.fingerprint;
        color = Colors.purple;
      } else if (Platform.isIOS) {
        platform = 'iOS Face ID / Touch ID';
        icon = LucideIcons.smartphone;
        color = Colors.orange;
      } else {
        platform = 'Platform authentication';
        icon = LucideIcons.lock;
        color = Colors.grey;
      }
    } catch (e) {
      platform = 'Web authentication';
      icon = LucideIcons.globe;
      color = Colors.blue;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            platform,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRawStateDisplay(BuildContext context, WebApisState state) {
    return Card(
      color: Colors.orange.shade50,
      child: ExpansionTile(
        leading: Icon(LucideIcons.code, color: Colors.orange.shade700),
        title: Text(
          'Raw State Data (Persisted)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
          ),
        ),
        subtitle: Text(
          'HydratedCubit state stored in local storage',
          style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade900,
            child: SelectableText(
              state.toString(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.green.shade300,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
