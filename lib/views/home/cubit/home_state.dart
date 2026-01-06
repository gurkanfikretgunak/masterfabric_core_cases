part of 'home_cubit.dart';

/// App info data model
class AppInfoData extends Equatable {
  final String appName;
  final String version;
  final String buildNumber;
  final String flavorName;
  final String flavorEnvironment;
  final String apiBaseUrl;
  final bool debugMode;
  final String packageId;
  final Flavor flavor;

  const AppInfoData({
    this.appName = '',
    this.version = '',
    this.buildNumber = '',
    this.flavorName = '',
    this.flavorEnvironment = '',
    this.apiBaseUrl = '',
    this.debugMode = false,
    this.packageId = '',
    this.flavor = Flavor.development,
  });

  /// Version display string
  String get versionDisplay => '$version ($buildNumber)';

  /// Debug mode display string
  String get debugModeDisplay => debugMode ? 'Enabled' : 'Disabled';

  @override
  List<Object?> get props => [
        appName,
        version,
        buildNumber,
        flavorName,
        flavorEnvironment,
        apiBaseUrl,
        debugMode,
        packageId,
        flavor,
      ];
}

/// Help item data model
class HelpItem extends Equatable {
  final String title;
  final String description;

  const HelpItem({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

/// Home screen state
class HomeState extends Equatable {
  final int counter;
  final bool isLoading;
  final AppInfoData appInfo;
  final List<HelpItem> helpItems;
  final bool isAppInfoLoaded;

  const HomeState({
    this.counter = 0,
    this.isLoading = true,
    this.appInfo = const AppInfoData(),
    this.helpItems = const [],
    this.isAppInfoLoaded = false,
  });

  HomeState copyWith({
    int? counter,
    bool? isLoading,
    AppInfoData? appInfo,
    List<HelpItem>? helpItems,
    bool? isAppInfoLoaded,
  }) {
    return HomeState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
      appInfo: appInfo ?? this.appInfo,
      helpItems: helpItems ?? this.helpItems,
      isAppInfoLoaded: isAppInfoLoaded ?? this.isAppInfoLoaded,
    );
  }

  @override
  List<Object?> get props => [
        counter,
        isLoading,
        appInfo,
        helpItems,
        isAppInfoLoaded,
      ];
}
