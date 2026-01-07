import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/app/flavor/widgets/flavor_banner.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Main application widget configured with MasterApp
class MyApp extends StatelessWidget {
  final GoRouter router;
  final bool showFlavorBanner;

  const MyApp({super.key, required this.router, this.showFlavorBanner = true});

  @override
  Widget build(BuildContext context) {
    // Get SettingsCubit for theme management
    final settingsCubit = GetIt.instance<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, state) {
        final currentTheme = state.isDarkMode 
            ? AppTheme.dark(state.primaryColor) 
            : AppTheme.light(state.primaryColor);
        
        return FlavorBanner(
          show: showFlavorBanner,
          child: Theme(
            data: currentTheme,
            child: MasterApp(
              router: router,
              shouldSetOrientation: true,
              preferredOrientations: [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ],
              showPerformanceOverlay: false,
              textDirection: TextDirection.ltr,
              fontScale: 1.0,
            ),
          ),
        );
      },
    );
  }
}
