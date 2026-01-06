# Flavor Management System

This folder contains the complete flavor management system for the MasterFabric Core Cases app.

## Structure

```
lib/app/flavor/
├── flavor_config.dart          # Core flavor configuration class
├── flavor_config_loader.dart   # YAML loader with fallback support
└── widgets/
    └── flavor_banner.dart      # Interactive flavor banner widget
```

## Features

### FlavorConfig
- Singleton pattern for flavor configuration
- Support for development, staging, and production environments
- Type-safe configuration access with `getConfig<T>()` and `getConfigOrDefault<T>()`
- Automatic app name generation based on flavor

### FlavorConfigLoader
- Loads configuration from `assets/flavor_config.yaml`
- **Robust fallback system**: If YAML loading fails, uses hardcoded fallback configs
- Validates required fields (apiBaseUrl)
- Recursive YAML to Map conversion
- Comprehensive error handling and logging

### FlavorBanner
- Interactive tab on the right edge of the screen
- Animated expand/collapse with smooth transitions
- Shows environment info and debug status
- Opens detailed configuration bottom sheet
- Auto-hides when bottom sheet is open
- Material Design compliant with proper context handling

## Usage

### Loading Configuration
```dart
// In main files
await FlavorConfigLoader.loadFromYaml(Flavor.development);
```

### Accessing Configuration
```dart
final config = FlavorConfig.instance;
final apiUrl = config.apiBaseUrl;
final timeout = config.getConfig<int>('apiTimeout') ?? 30000;
```

### Using Banner
```dart
FlavorBanner(
  show: true, // Set to false for production
  child: MyApp(),
)
```

## Fallback Behavior

If `assets/flavor_config.yaml` is missing or corrupted, the system automatically falls back to hardcoded configurations:

- **Development**: Debug enabled, mock data, extended timeouts
- **Staging**: Debug enabled, analytics enabled, standard timeouts
- **Production**: Debug disabled, analytics enabled, optimized timeouts

## Migration Notes

- Moved from `lib/app/helpers/` to `lib/app/flavor/` for better organization
- Removed unused `FlavorText` widget
- Added comprehensive error handling and fallbacks
- Improved widget structure and overflow handling