import 'package:get_it/get_it.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/views/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/web_apis/cubit/web_apis_cubit.dart';
import 'package:masterfabric_core_cases/views/hive_ce/cubit/hive_ce_cubit.dart';
import 'package:masterfabric_core_cases/views/bottom_sheet_test/cubit/bottom_sheet_test_cubit.dart';

/// Dependency injection setup for the application
class DependencyInjection {
  static final GetIt _getIt = GetIt.instance;

  /// Register all cubits with GetIt
  static void registerDependencies() {
    // Application cubits
    _getIt.registerFactory<HomeCubit>(() => HomeCubit());
    _getIt.registerFactory<SettingsCubit>(() => SettingsCubit());
    _getIt.registerFactory<WebApisCubit>(() => WebApisCubit());
    _getIt.registerFactory<HiveCeCubit>(() => HiveCeCubit());
    _getIt.registerFactory<BottomSheetTestCubit>(() => BottomSheetTestCubit());

    // masterfabric_core cubits (used in routes)
    _getIt.registerFactory<SplashCubit>(() => SplashCubit());
  }

  /// Get the GetIt instance
  static GetIt get instance => _getIt;
}
