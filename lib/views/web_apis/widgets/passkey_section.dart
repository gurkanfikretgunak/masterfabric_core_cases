import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
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
            Divider(color: context.dividerColor),
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
    );
  }
}

class _CreatePasskeyButton extends StatelessWidget {
  final WebApisState state;
  final WebApisCubit viewModel;

  const _CreatePasskeyButton({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final enabled = state.passkeyEnabled && !state.isAuthenticating;
    final isDark = context.isDarkMode;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? () => _showCreatePasskeyDialog(context, viewModel) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: enabled 
              ? AppColors.success 
              : (isDark ? AppColors.dark.surfaceVariant : AppColors.light.surfaceVariant),
          foregroundColor: enabled ? Colors.white : context.textTertiaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.keyRound, size: 18),
            const SizedBox(width: 10),
            const Text(
              'Create New Passkey',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePasskeyDialog(BuildContext context, WebApisCubit viewModel) {
    final usernameController = TextEditingController();
    final displayNameController = TextEditingController();
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.dark.dialogBackground : AppColors.light.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius + 5),
        ),
        title: Row(
          children: [
            Icon(LucideIcons.keyRound, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Create Passkey',
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
                prefixIcon: const Icon(LucideIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: displayNameController,
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Display Name (Optional)',
                hintText: 'Enter display name',
                prefixIcon: const Icon(LucideIcons.userRound),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary),
            ),
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
                      backgroundColor: AppColors.success,
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.check, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Passkey created successfully!')),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
            ),
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
    final enabled = state.passkeyEnabled && !state.isAuthenticating;
    final isDark = context.isDarkMode;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? () => _authenticateWithAlert(context, viewModel) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: enabled 
              ? AppColors.primary 
              : (isDark ? AppColors.dark.surfaceVariant : AppColors.light.surfaceVariant),
          foregroundColor: enabled ? Colors.white : context.textTertiaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.isAuthenticating ? LucideIcons.loader : LucideIcons.lockOpen,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              state.isAuthenticating ? 'Authenticating...' : 'Authenticate with Passkey',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticateWithAlert(
    BuildContext context,
    WebApisCubit viewModel,
  ) async {
    final isDark = context.isDarkMode;
    
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.dark.dialogBackground : AppColors.light.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius + 5),
        ),
        title: Row(
          children: [
            Icon(LucideIcons.fingerprint, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Authenticate with Passkey',
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will trigger platform authentication:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const _PlatformAuthInfo(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(kRadius),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.info, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a demo. In production, you would authenticate with your saved passkey.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
                      ),
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
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(LucideIcons.fingerprint),
            label: const Text('Authenticate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
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
            backgroundColor: AppColors.success,
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.check, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Flexible(child: Text('Authentication successful!')),
              ],
            ),
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
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Row(
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
      ),
    );
  }

  (String, IconData, Color) _getPlatformInfo() {
    try {
      if (kIsWeb) {
        return ('Browser passkey dialog', LucideIcons.globe, AppColors.primary);
      } else if (Platform.isMacOS) {
        return ('macOS Touch ID / Keychain', LucideIcons.fingerprint, AppColors.purple);
      } else if (Platform.isIOS) {
        return ('iOS Face ID / Touch ID', LucideIcons.smartphone, AppColors.warning);
      }
    } catch (_) {}
    return ('Platform authentication', LucideIcons.lock, AppColors.primary);
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: context.textPrimaryColor,
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: Icon(LucideIcons.trash2, size: 14, color: AppColors.error),
          label: Text('Clear All', style: TextStyle(color: AppColors.error)),
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
    final isDark = context.isDarkMode;

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
              color: AppColors.purple.withValues(alpha: isDark ? 0.2 : 0.15),
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(LucideIcons.key, color: AppColors.purple, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passkey.displayName ?? passkey.username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Username: ${passkey.username}',
                  style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                ),
                Text(
                  'Created: ${dateFormat.format(passkey.createdAt)}',
                  style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                ),
                Text(
                  'Last used: ${dateFormat.format(passkey.lastUsed)}',
                  style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.trash2, size: 18, color: AppColors.error),
            onPressed: () => viewModel.removePasskey(passkey.id),
            tooltip: 'Remove passkey',
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
          Icon(LucideIcons.key, size: 48, color: context.iconSecondaryColor),
          const SizedBox(height: 8),
          Text(
            'No passkeys stored',
            style: TextStyle(
              color: context.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create a passkey to get started',
            style: TextStyle(color: context.textTertiaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
