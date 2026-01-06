import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/app/flavor/flavor_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'home_state.dart';

/// Cubit for Home screen - contains all business logic
class HomeCubit extends BaseViewModelCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// Initialize the home screen - load all required data
  Future<void> initialize() async {
    await loadAppInfo();
    loadHelpItems();
    emit(state.copyWith(isLoading: false));
  }

  /// Load app information from package info and flavor config
  Future<void> loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final flavor = FlavorConfig.instance;

      final appInfo = AppInfoData(
        appName: flavor.appName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        flavorName: flavor.name,
        flavorEnvironment: flavor.flavor.name.toUpperCase(),
        apiBaseUrl: flavor.apiBaseUrl,
        debugMode: flavor.debugMode,
        packageId: packageInfo.packageName,
        flavor: flavor.flavor,
      );

      emit(state.copyWith(appInfo: appInfo, isAppInfoLoaded: true));
    } catch (e) {
      debugPrint('Error loading app info: $e');
    }
  }

  /// Load help items data
  void loadHelpItems() {
    const helpItems = [
      HelpItem(
        title: '🎯 What is this?',
        description:
            'A demo app showcasing masterfabric_core package capabilities including state management, flavors, and modern Flutter architecture.',
      ),
      HelpItem(
        title: '⚙️ Settings (HydratedCubit)',
        description:
            'Demonstrates persistent state management. Your settings are automatically saved and restored when you restart the app.',
      ),
      HelpItem(
        title: '🌐 Web APIs',
        description:
            'Shows Web Bluetooth and WebAuthn (Passkeys) integration for modern authentication and device connectivity.',
      ),
      HelpItem(
        title: '🔄 Counter Demo',
        description:
            'Simple counter using BLoC pattern. Tap the + button to increment.',
      ),
      HelpItem(
        title: '📱 Flavor System',
        description:
            'Multi-environment support (dev/staging/prod) with different configurations per environment.',
      ),
    ];

    emit(state.copyWith(helpItems: helpItems));
  }

  /// Get color based on flavor
  Color getFlavorColor() {
    switch (state.appInfo.flavor) {
      case Flavor.development:
        return Colors.blue;
      case Flavor.staging:
        return Colors.orange;
      case Flavor.production:
        return Colors.green;
    }
  }

  /// Trigger settings language change
  void triggerTheSettingLangChange(String lang) {
    final settingsCubit = GetIt.instance<SettingsCubit>();
    settingsCubit.changeLanguage(lang);
  }

  /// Increment counter
  void incrementCounter() {
    emit(state.copyWith(counter: state.counter + 1));
  }

  /// Reset counter to zero
  void resetCounter() {
    emit(state.copyWith(counter: 0));
  }

  /// Decrement counter
  void decrementCounter() {
    if (state.counter > 0) {
      emit(state.copyWith(counter: state.counter - 1));
    }
  }
}
