import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_cases/views/home/widgets/raw_settings_card.dart';
import 'package:masterfabric_core_cases/app/routes.dart';
import 'package:masterfabric_core_cases/app/flavor/flavor_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Home screen view
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  /// Show app info dialog with flavor and version details
  void _showAppInfo(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final flavor = FlavorConfig.instance;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(LucideIcons.info, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('App Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                'App Name',
                flavor.appName,
                LucideIcons.package,
                Colors.blue,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'Version',
                '${packageInfo.version} (${packageInfo.buildNumber})',
                LucideIcons.tag,
                Colors.green,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'Flavor',
                flavor.name,
                LucideIcons.layers,
                _getFlavorColor(flavor.flavor),
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'Environment',
                flavor.flavor.name.toUpperCase(),
                LucideIcons.server,
                Colors.orange,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'API Base URL',
                flavor.apiBaseUrl,
                LucideIcons.globe,
                Colors.purple,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'Debug Mode',
                flavor.debugMode ? 'Enabled' : 'Disabled',
                flavor.debugMode ? LucideIcons.bug : LucideIcons.shield,
                flavor.debugMode ? Colors.red : Colors.green,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                'Package ID',
                packageInfo.packageName,
                LucideIcons.package2,
                Colors.teal,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build info row widget
  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get color based on flavor
  Color _getFlavorColor(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return Colors.blue;
      case Flavor.staging:
        return Colors.orange;
      case Flavor.production:
        return Colors.green;
    }
  }

  /// Show help dialog explaining the demo features
  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(LucideIcons.circleHelp, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Demo Guide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpSection(
                '🎯 What is this?',
                'A demo app showcasing masterfabric_core package capabilities including state management, flavors, and modern Flutter architecture.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                '⚙️ Settings (HydratedCubit)',
                'Demonstrates persistent state management. Your settings are automatically saved and restored when you restart the app.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                '🌐 Web APIs',
                'Shows Web Bluetooth and WebAuthn (Passkeys) integration for modern authentication and device connectivity.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                '🔄 Counter Demo',
                'Simple counter using BLoC pattern. Tap the + button to increment.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                '📱 Flavor System',
                'Multi-environment support (dev/staging/prod) with different configurations per environment.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  /// Build help section widget
  Widget _buildHelpSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<HomeCubit>()..initialize(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                // Help/Guide button
                IconButton(
                  icon: const Icon(LucideIcons.circleHelp),
                  tooltip: 'Demo Guide',
                  onPressed: () => _showHelp(context),
                ),
                // App info button
                IconButton(
                  icon: const Icon(LucideIcons.info),
                  tooltip: 'App Info & Flavor',
                  onPressed: () => _showAppInfo(context),
                ),
                // Reset counter button
                IconButton(
                  icon: const Icon(LucideIcons.rotateCcw),
                  tooltip: 'Reset Counter',
                  onPressed: () {
                    context.read<HomeCubit>().resetCounter();
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
                            const Flexible(child: Text('Counter reset to 0')),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                // Settings navigation button
                IconButton(
                  icon: const Icon(LucideIcons.settings),
                  tooltip: 'Go to Settings',
                  onPressed: () => context.go(AppRoutes.settings),
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('MF Core Demo'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Successfully passed through Splash Screen!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Counter: ${state.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.settings),
                    icon: const Icon(LucideIcons.settings),
                    label: const Text('Settings (HydratedCubit)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.webApis),
                    icon: const Icon(LucideIcons.bluetooth),
                    label: const Text('Web APIs (Bluetooth & Passkeys)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.info,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Settings page uses HydratedCubit\nand automatically saves state',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Raw Settings Card
                  const RawSettingsCard(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<HomeCubit>().incrementCounter(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
