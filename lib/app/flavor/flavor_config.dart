/// Enum for app flavors/environments
enum Flavor { development, staging, production }

/// Flavor configuration class
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;
  final String appName;
  final bool debugMode;
  final Map<String, dynamic> additionalConfig;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.apiBaseUrl,
    required this.appName,
    required this.debugMode,
    this.additionalConfig = const {},
  });

  static FlavorConfig? _instance;

  /// Get the current flavor configuration instance
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig has not been initialized. Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if instance is initialized
  static bool get isInitialized => _instance != null;

  /// Initialize the flavor configuration
  static void initialize({
    required Flavor flavor,
    required String apiBaseUrl,
    String? appName,
    bool? debugMode,
    Map<String, dynamic> additionalConfig = const {},
  }) {
    _instance = FlavorConfig._(
      flavor: flavor,
      name: flavor.name,
      apiBaseUrl: apiBaseUrl,
      appName: appName ?? _getDefaultAppName(flavor),
      debugMode: debugMode ?? (flavor != Flavor.production),
      additionalConfig: additionalConfig,
    );
  }

  /// Get default app name based on flavor
  static String _getDefaultAppName(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return 'MasterFabric [DEV]';
      case Flavor.staging:
        return 'MasterFabric [STAGING]';
      case Flavor.production:
        return 'MasterFabric';
    }
  }

  /// Check if current flavor is development
  bool get isDevelopment => flavor == Flavor.development;

  /// Check if current flavor is staging
  bool get isStaging => flavor == Flavor.staging;

  /// Check if current flavor is production
  bool get isProduction => flavor == Flavor.production;

  /// Get configuration value by key
  T? getConfig<T>(String key) {
    return additionalConfig[key] as T?;
  }

  /// Get configuration value with default
  T getConfigOrDefault<T>(String key, T defaultValue) {
    return additionalConfig[key] as T? ?? defaultValue;
  }

  @override
  String toString() {
    return 'FlavorConfig(\n'
        '  flavor: $name,\n'
        '  apiBaseUrl: $apiBaseUrl,\n'
        '  appName: $appName,\n'
        '  debugMode: $debugMode,\n'
        '  additionalConfig: $additionalConfig\n'
        ')';
  }
}
