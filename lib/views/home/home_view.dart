import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_cases/views/home/widgets/raw_settings_card.dart';
import 'package:masterfabric_core_cases/app/routes.dart';

/// Home screen view
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<HomeCubit>()..initialize(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCcw),
                  tooltip: 'Reset Counter',
                  onPressed: () {
                    context.read<HomeCubit>().triggerTheSettingLangChange('tr');
                  },
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('MasterFabric Core Package'),
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
