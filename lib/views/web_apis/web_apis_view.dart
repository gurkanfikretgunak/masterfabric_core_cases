import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_state.dart';
import 'package:masterfabric_core_cases/views/web_apis/widgets/widgets.dart';

/// Web APIs View - Demonstrates Bluetooth and Passkey Web APIs
class WebApisView extends MasterViewHydratedCubit<WebApisCubit, WebApisState> {
  WebApisView({super.key, required super.goRoute})
      : super(
          currentView: MasterViewHydratedCubitTypes.content,
          arguments: const {'title': 'Web APIs'},
          coreAppBar: (context, viewModel) => _buildAppBar(context, goRoute),
        );

  static AppBar _buildAppBar(BuildContext context, Function(String) goRoute) {
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
          onPressed: () => _showInfoDialog(context),
          tooltip: 'Info',
        ),
      ],
    );
  }

  static void _showInfoDialog(BuildContext context) {
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
  }

  @override
  Future<void> initialContent(
    WebApisCubit viewModel,
    BuildContext context,
  ) async {
    debugPrint('Web APIs View Initialized');
    viewModel.recheckApiSupport();
  }

  @override
  Widget viewContent(
    BuildContext context,
    WebApisCubit viewModel,
    WebApisState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(state: state),
          const SizedBox(height: 24),
          const SectionHeader(
            icon: LucideIcons.bluetooth,
            title: 'Web Bluetooth API',
          ),
          BluetoothSection(viewModel: viewModel, state: state),
          const SizedBox(height: 24),
          const SectionHeader(
            icon: LucideIcons.key,
            title: 'WebAuthn (Passkeys)',
          ),
          PasskeySection(viewModel: viewModel, state: state),
          const SizedBox(height: 32),
          _RawStateDisplay(state: state),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final WebApisState state;

  const _InfoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                StatusChip(
                  icon: LucideIcons.bluetooth,
                  label: 'Bluetooth',
                  enabled: state.bluetoothEnabled,
                ),
                StatusChip(
                  icon: LucideIcons.key,
                  label: 'Passkeys',
                  enabled: state.passkeyEnabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RawStateDisplay extends StatelessWidget {
  final WebApisState state;

  const _RawStateDisplay({required this.state});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16),
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
