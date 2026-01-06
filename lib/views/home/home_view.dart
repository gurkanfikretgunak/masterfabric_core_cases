import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer, AppRoutes;
import 'package:masterfabric_core_cases/views/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_cases/views/home/widgets/raw_settings_card.dart';
import 'package:masterfabric_core_cases/app/routes.dart';

/// Standard border radius used across the app
const double _kRadius = 7.0;

/// Home screen view using MasterViewCubit from masterfabric_core
class HomeView extends MasterViewCubit<HomeCubit, HomeState> {
  HomeView({super.key, required super.goRoute})
      : super(
          currentView: MasterViewCubitTypes.content,
          arguments: const {'title': 'Home'},
          coreAppBar: (context, viewModel) => _buildAppBar(context, goRoute),
        );

  static AppBar _buildAppBar(BuildContext context, Function(String) goRoute) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      centerTitle: false,
      title: const Text(
        'MasterFabric Core',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.settings, size: 20),
          tooltip: 'Settings',
          onPressed: () => goRoute(AppRoutes.settings),
        ),
      ],
    );
  }

  @override
  Future<void> initialContent(HomeCubit viewModel, BuildContext context) async {
    debugPrint('Home View Initialized with MasterViewCubit');
    await viewModel.initialize();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeCubit viewModel,
    HomeState state,
  ) {
        return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
          body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            _WhiteCard(
            child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(_kRadius),
                    ),
                    child: const Icon(
                      LucideIcons.circleCheck,
                      color: Color(0xFF4CAF50),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Successfully passed through Splash Screen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Counter Card
            _WhiteCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(_kRadius),
                    ),
                    child: const Icon(
                      LucideIcons.hash,
                      color: Color(0xFF2196F3),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Counter',
                        style: TextStyle(
                            fontSize: 13,
                          color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${state.counter}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                      ),
                    ),
                  ],
                    ),
                  ),
                  IconButton(
                    onPressed: viewModel.resetCounter,
                    icon: Icon(
                      LucideIcons.rotateCcw,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                    tooltip: 'Reset',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Section
            Text(
              'Navigate',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _NavigationTile(
              icon: LucideIcons.settings,
              title: 'Settings',
              subtitle: 'HydratedCubit persistent state',
              onTap: () => goRoute(AppRoutes.settings),
            ),
            const SizedBox(height: 10),
            _NavigationTile(
              icon: LucideIcons.bluetooth,
              title: 'Web APIs',
              subtitle: 'Bluetooth & Passkeys integration',
              onTap: () => goRoute(AppRoutes.webApis),
              iconColor: const Color(0xFF7C4DFF),
              iconBgColor: const Color(0xFFEDE7F6),
                ),
                const SizedBox(height: 32),

            // Divider with explanation
            _SectionDivider(
              icon: LucideIcons.database,
              title: 'Developer Debug',
              description:
                  'This section shows the raw state data from HydratedCubit. '
                  'It demonstrates how state persistence works - all settings '
                  'are automatically serialized to JSON and saved locally.',
            ),
            const SizedBox(height: 16),

            // Raw Settings Card
                const RawSettingsCard(),
            const SizedBox(height: 80),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: viewModel.incrementCounter,
            tooltip: 'Increment',
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kRadius + 5),
        ),
        child: const Icon(LucideIcons.plus, size: 22),
      ),
    );
  }
}

/// White card container with standard radius
class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Navigation tile for menu items
class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBgColor;

  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? const Color(0xFF2196F3);
    final bgColor = iconBgColor ?? const Color(0xFFE3F2FD);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_kRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_kRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(_kRadius),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section divider with icon and explanation
class _SectionDivider extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SectionDivider({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(_kRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(_kRadius),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.lightbulb,
                size: 16,
                color: Color(0xFFF9A825),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
