import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/app/flavor/widgets/flavor_banner.dart';
import 'package:masterfabric_core_cases/views/home/home_view.dart';
import 'package:masterfabric_core_cases/views/settings/settings_view.dart';
import 'package:masterfabric_core_cases/views/web_apis/web_apis_view.dart';
import 'package:masterfabric_core_cases/views/hive_ce/hive_ce_view.dart';
import 'package:masterfabric_core_cases/views/bottom_sheet_test/bottom_sheet_test_view.dart';

/// Application route definitions
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String webApis = '/web-apis';
  static const String hiveCe = '/hive-ce';
  static const String bottomSheetTest = '/bottom-sheet-test';

  /// Create GoRouter configuration
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: flavorBannerNavigatorKey,
      initialLocation: splash,
      routes: [
        // Splash Screen Route
        GoRoute(
          path: splash,
          builder: (context, state) => SplashView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),

        // Home Route
        GoRoute(
          path: home,
          builder: (context, state) =>
              HomeView(goRoute: (path) => context.go(path)),
        ),

        // Settings Route (HydratedCubit Example)
        GoRoute(
          path: settings,
          builder: (context, state) =>
              SettingsView(goRoute: (path) => context.go(path)),
        ),

        // Web APIs Route (Bluetooth & Passkeys)
        GoRoute(
          path: webApis,
          builder: (context, state) =>
              WebApisView(goRoute: (path) => context.go(path)),
        ),

        // Hive CE Route (HiveCeHelper Demo)
        GoRoute(
          path: hiveCe,
          builder: (context, state) =>
              HiveCeView(goRoute: (path) => context.go(path)),
        ),

        // Bottom Sheet Test Route
        GoRoute(
          path: bottomSheetTest,
          builder: (context, state) =>
              BottomSheetTestView(goRoute: (path) => context.go(path)),
        ),
      ],
    );
  }
}
