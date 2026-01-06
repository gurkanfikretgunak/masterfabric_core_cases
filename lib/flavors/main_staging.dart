import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/app/app.dart';
import 'package:masterfabric_core_cases/app/di/dependency_injection.dart';
import 'package:masterfabric_core_cases/app/flavor/flavor_config.dart';
import 'package:masterfabric_core_cases/app/flavor/flavor_config_loader.dart';
import 'package:masterfabric_core_cases/app/routes.dart' as app_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load flavor configuration from YAML
  await FlavorConfigLoader.loadFromYaml(Flavor.staging);

  // Register dependencies
  DependencyInjection.registerDependencies();

  // Initialize MasterApp components - HydratedBloc enabled
  await MasterApp.runBefore(
    hydrated: true, // Enable state persistence for HydratedCubit
  );

  // Create Router
  final router = app_routes.AppRoutes.createRouter();

  runApp(MyApp(router: router, showFlavorBanner: true));
}
