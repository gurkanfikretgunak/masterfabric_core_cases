import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/app/flavor/widgets/flavor_banner.dart';

/// Main application widget configured with MasterApp
class MyApp extends StatelessWidget {
  final GoRouter router;
  final bool showFlavorBanner;

  const MyApp({super.key, required this.router, this.showFlavorBanner = true});

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      show: showFlavorBanner,
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
    );
  }
}
