import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_state.dart';

/// Passkey authentication section
class PasskeySection extends StatelessWidget {
  final WebApisCubit viewModel;
  final WebApisState state;

  const PasskeySection({
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
            _CreatePasskeyButton(state: state, viewModel: viewModel),
            const SizedBox(height: 12),
            _AuthenticateButton(state: state, viewModel: viewModel),
            if (state.lastSuccessfulAuth != null) ...[
              const SizedBox(height: 12),
              MessageContainer(
                message: 'Last authenticated: ${state.lastSuccessfulAuth}',
                type: MessageType.success,
              ),
            ],
            if (state.authError != null) ...[
              const SizedBox(height: 12),
              MessageContainer(
                message: state.authError!,
                type: MessageType.error,
                onDismiss: viewModel.clearAuthError,
              ),
            ],
            if (state.passkeys.isNotEmpty) ...[
              const SizedBox(height: 16),
              _PasskeyListHeader(
                count: state.passkeys.length,
                onClear: viewModel.clearPasskeys,
              ),
              const Divider(),
              ...state.passkeys.map(
                (passkey) => _PasskeyItem(
                  passkey: passkey,
                  viewModel: viewModel,
                ),
              ),
            ] else if (!state.isAuthenticating) ...[
              const SizedBox(height: 16),
              const _EmptyState(),
            ],
          ],
        ),
      ),
    );
  }
}

class _CreatePasskeyButton extends StatelessWidget {
  final WebApisState state;
  final WebApisCubit viewModel;

  const _CreatePasskeyButton({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                await viewModel.createPasskey(
                  username: usernameController.text.trim(),
                  displayName: displayNameController.text.trim().isEmpty
                      ? null
                      : displayNameController.text.trim(),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.check, color: Colors.white, size: 20),
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
}

class _AuthenticateButton extends StatelessWidget {
  final WebApisState state;
  final WebApisCubit viewModel;

  const _AuthenticateButton({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: state.passkeyEnabled && !state.isAuthenticating
            ? () => _authenticateWithAlert(context, viewModel)
            : null,
        icon: Icon(
          state.isAuthenticating ? LucideIcons.loader : LucideIcons.lockOpen,
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
    );
  }

  Future<void> _authenticateWithAlert(
    BuildContext context,
    WebApisCubit viewModel,
  ) async {
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
            const _PlatformAuthInfo(),
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
}

class _PlatformAuthInfo extends StatelessWidget {
  const _PlatformAuthInfo();

  @override
  Widget build(BuildContext context) {
    final (platform, icon, color) = _getPlatformInfo();

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

  (String, IconData, Color) _getPlatformInfo() {
    try {
      if (kIsWeb) {
        return ('Browser passkey dialog', LucideIcons.globe, Colors.blue);
      } else if (Platform.isMacOS) {
        return (
          'macOS Touch ID / Keychain',
          LucideIcons.fingerprint,
          Colors.purple
        );
      } else if (Platform.isIOS) {
        return (
          'iOS Face ID / Touch ID',
          LucideIcons.smartphone,
          Colors.orange
        );
      }
    } catch (_) {}
    return ('Platform authentication', LucideIcons.lock, Colors.grey);
  }
}

class _PasskeyListHeader extends StatelessWidget {
  final int count;
  final VoidCallback onClear;

  const _PasskeyListHeader({required this.count, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Stored Passkeys ($count)',
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

class _PasskeyItem extends StatelessWidget {
  final PasskeyCredential passkey;
  final WebApisCubit viewModel;

  const _PasskeyItem({required this.passkey, required this.viewModel});

  @override
  Widget build(BuildContext context) {
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
          child:
              Icon(LucideIcons.key, color: Colors.purple.shade700, size: 24),
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
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(LucideIcons.key, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text('No passkeys stored',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            'Create a passkey to get started',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

