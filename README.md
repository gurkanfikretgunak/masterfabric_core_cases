# MasterFabric Core Cases

A Flutter demo application showcasing the integration and usage of the `masterfabric_core` package with multiple features including authentication, settings management, and web API demonstrations.

## Overview

This project demonstrates a production-ready Flutter application structure with:
- **Multi-flavor support** (Development, Staging, Production)
- **State management** using flutter_bloc with HydratedBloc for persistence
- **Dependency injection** via get_it and injectable
- **Navigation** with go_router
- **Core features** powered by masterfabric_core package

## Features

- 🏠 **Home**: Main dashboard with navigation to all features
- ⚙️ **Settings**: App configuration and preferences management
- 🌐 **Web APIs**: HTTP request testing and API interactions
- 🔐 **Local Authentication**: Biometric authentication support
- 🎨 **Theme Support**: Light/dark mode theming
- 💾 **State Persistence**: Automatic state saving with HydratedBloc

## Project Structure

```
lib/
├── app/              # Core application setup
│   ├── di/          # Dependency injection configuration
│   ├── flavor/      # Flavor configuration and widgets
│   ├── app.dart     # Main app widget
│   └── routes.dart  # Route definitions
├── features/        # Feature modules
│   ├── home/
│   ├── settings/
│   └── web_apis/
├── flavors/         # Flavor entry points
│   ├── main_development.dart
│   ├── main_staging.dart
│   └── main_production.dart
└── views/           # UI views for each feature
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Dart SDK
- Make (for build automation)

### Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd masterfabric_core_cases

# Run initial setup (installs dependencies, sets up scripts)
make setup

# Run code generation
make codegen

# Generate app icons (optional)
make icons

# Check iOS flavor configuration (macOS only)
make ios-setup
```

> **Note for iOS**: The project includes custom schemes (development, staging, production) for iOS builds. However, you need to configure build configurations in Xcode. Run `make ios-setup` for instructions, or see the [iOS Flavor Configuration](#ios-flavor-configuration) section below.

### Running the App

#### Using Make commands (Recommended)

```bash
# Run development flavor
make run-dev

# Run staging flavor
make run-stg

# Run production flavor
make run-prod
```

#### Using Flutter commands directly

```bash
# Development
flutter run --flavor development -t lib/flavors/main_development.dart

# Staging
flutter run --flavor staging -t lib/flavors/main_staging.dart

# Production
flutter run --flavor production -t lib/flavors/main_production.dart
```

### Building

```bash
# Complete pre-build process (clean, setup, codegen, icons)
make prebuild

# Build all flavors (Android & iOS)
make build-all

# Build specific flavors
make build-dev    # Development
make build-stg    # Staging
make build-prod   # Production
```

## Available Make Commands

Run `make help` to see all available commands:

- `make setup` - Initial project setup
- `make ios-setup` - Configure iOS flavors (requires Xcode)
- `make ios-test` - Test iOS flavor configuration
- `make test-scripts` - Run unit tests for build scripts
- `make clean` - Clean build artifacts
- `make codegen` - Run code generation
- `make icons` - Generate app icons
- `make prebuild` - Complete pre-build process
- `make run-dev/stg/prod` - Run specific flavor
- `make build-dev/stg/prod` - Build specific flavor
- `make build-all` - Build all flavors

> 💡 **Testing**: See [TESTING.md](TESTING.md) for comprehensive testing documentation and troubleshooting.

## Key Dependencies

- **masterfabric_core** ^0.0.4 - Core functionality package
- **flutter_bloc** ^9.1.0 - State management
- **go_router** ^15.1.3 - Navigation
- **get_it** ^8.3.0 - Service locator
- **injectable** ^2.5.0 - Code generation for dependency injection
- **dio** ^5.7.0 - HTTP client
- **local_auth** ^2.3.0 - Biometric authentication
- **shared_preferences** ^2.3.4 - Local storage

## Configuration

Flavor configurations are managed through:
- `assets/flavor_config.yaml` - YAML-based flavor settings
- `assets/flavor_config.json` - JSON-based flavor settings
- `assets/app_config.json` - Application-wide configuration

## Code Generation

This project uses code generation for:
- Dependency injection (injectable_generator)
- JSON serialization (json_serializable)
- Immutable models (freezed)

Run `make codegen` or `flutter pub run build_runner build --delete-conflicting-outputs` after modifying annotated classes.

## Development

### Adding a New Feature

1. Create feature folder in `lib/features/`
2. Add corresponding view in `lib/views/`
3. Register routes in `lib/app/routes.dart`
4. Add dependencies if needed in `lib/app/di/`

### Testing

```bash
flutter test
```

## Resources

- [MasterFabric Core Documentation](https://pub.dev/packages/masterfabric_core)
- [Flutter Documentation](https://docs.flutter.dev/)
- [go_router Documentation](https://pub.dev/packages/go_router)
- [flutter_bloc Documentation](https://bloclibrary.dev/)

## iOS Flavor Configuration

The project requires flavor-specific build configurations in Xcode for iOS builds. Follow these steps to set them up:

### Option 1: Using Xcode (Recommended)

1. Open the iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Click on **Runner** in the project navigator (the blue icon at the top)

3. Make sure you select the **Runner PROJECT** (not the Runner target)

4. Under **Info** tab, expand **Configurations**

5. For each flavor (development, staging, production), duplicate the Debug configuration:
   - Click the **+** button below the configurations list
   - Select **Duplicate "Debug" Configuration**
   - Name it: `Debug-development`, `Debug-staging`, `Debug-production`

6. Repeat for Release configurations:
   - Duplicate "Release" Configuration three times
   - Name them: `Release-development`, `Release-staging`, `Release-production`

7. Repeat for Profile configurations:
   - Duplicate "Profile" Configuration three times
   - Name them: `Profile-development`, `Profile-staging`, `Profile-production`

### Option 2: Running Without Flavors

If you don't need flavor-specific configurations for iOS, you can run without the `--flavor` flag:

```bash
# Run on iOS without flavor
flutter run -t lib/flavors/main_development.dart

# For other flavors
flutter run -t lib/flavors/main_staging.dart
flutter run -t lib/flavors/main_production.dart
```
### Verifying the Setup

After setting up the configurations, you can test them:

```bash
make ios-test
```

This will verify:
- ✓ All scheme files exist and are valid
- ✓ Build configurations are properly set up
- ✓ Project structure is correct

If all tests pass, you can run:

```bash
make run-dev   # or run-stg, run-prod
```

The custom schemes (development, staging, production) are already configured in the project.
The custom schemes (development, staging, production) are already configured in the project.
