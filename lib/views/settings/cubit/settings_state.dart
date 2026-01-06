import 'package:equatable/equatable.dart';

/// Settings State - Persisted across app restarts with HydratedCubit
class SettingsState extends Equatable {
  // 🎨 Appearance
  final bool isDarkMode;
  final String language;
  final double fontSize;
  final String primaryColor;
  final String accentColor;

  // 🔔 Notifications
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;

  // 🎵 Sounds & Haptics
  final bool soundEffects;
  final bool vibration;
  final double volume;

  // 🔐 Security & Privacy
  final bool biometricAuth;
  final bool pinLock;
  final bool autoLock;
  final int autoLockTimeout; // minutes

  // 🌐 Network & Data
  final bool wifiOnlyDownload;
  final bool autoDownloadUpdates;
  final double maxCacheSize; // MB

  // 👤 Profile
  final String username;
  final String email;
  final String avatarUrl;

  // ⚡ Performance
  final bool autoSave;
  final double animationSpeed;
  final bool reducedMotion;
  final bool dataCompression;

  const SettingsState({
    // Appearance
    this.isDarkMode = false,
    this.language = 'tr',
    this.fontSize = 14.0,
    this.primaryColor = 'blue',
    this.accentColor = 'purple',
    // Notifications
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    // Sounds
    this.soundEffects = true,
    this.vibration = true,
    this.volume = 0.7,
    // Security
    this.biometricAuth = false,
    this.pinLock = false,
    this.autoLock = true,
    this.autoLockTimeout = 5,
    // Network
    this.wifiOnlyDownload = false,
    this.autoDownloadUpdates = true,
    this.maxCacheSize = 100.0,
    // Profile
    this.username = 'User',
    this.email = 'user@example.com',
    this.avatarUrl = '',
    // Performance
    this.autoSave = true,
    this.animationSpeed = 1.0,
    this.reducedMotion = false,
    this.dataCompression = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    double? fontSize,
    String? primaryColor,
    String? accentColor,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? soundEffects,
    bool? vibration,
    double? volume,
    bool? biometricAuth,
    bool? pinLock,
    bool? autoLock,
    int? autoLockTimeout,
    bool? wifiOnlyDownload,
    bool? autoDownloadUpdates,
    double? maxCacheSize,
    String? username,
    String? email,
    String? avatarUrl,
    bool? autoSave,
    double? animationSpeed,
    bool? reducedMotion,
    bool? dataCompression,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      fontSize: fontSize ?? this.fontSize,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      soundEffects: soundEffects ?? this.soundEffects,
      vibration: vibration ?? this.vibration,
      volume: volume ?? this.volume,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      pinLock: pinLock ?? this.pinLock,
      autoLock: autoLock ?? this.autoLock,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      wifiOnlyDownload: wifiOnlyDownload ?? this.wifiOnlyDownload,
      autoDownloadUpdates: autoDownloadUpdates ?? this.autoDownloadUpdates,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      autoSave: autoSave ?? this.autoSave,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      dataCompression: dataCompression ?? this.dataCompression,
    );
  }

  /// Convert state to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'fontSize': fontSize,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'soundEffects': soundEffects,
      'vibration': vibration,
      'volume': volume,
      'biometricAuth': biometricAuth,
      'pinLock': pinLock,
      'autoLock': autoLock,
      'autoLockTimeout': autoLockTimeout,
      'wifiOnlyDownload': wifiOnlyDownload,
      'autoDownloadUpdates': autoDownloadUpdates,
      'maxCacheSize': maxCacheSize,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'autoSave': autoSave,
      'animationSpeed': animationSpeed,
      'reducedMotion': reducedMotion,
      'dataCompression': dataCompression,
    };
  }

  /// Create state from JSON for restoration
  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'tr',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      primaryColor: json['primaryColor'] as String? ?? 'blue',
      accentColor: json['accentColor'] as String? ?? 'purple',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      soundEffects: json['soundEffects'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.7,
      biometricAuth: json['biometricAuth'] as bool? ?? false,
      pinLock: json['pinLock'] as bool? ?? false,
      autoLock: json['autoLock'] as bool? ?? true,
      autoLockTimeout: json['autoLockTimeout'] as int? ?? 5,
      wifiOnlyDownload: json['wifiOnlyDownload'] as bool? ?? false,
      autoDownloadUpdates: json['autoDownloadUpdates'] as bool? ?? true,
      maxCacheSize: (json['maxCacheSize'] as num?)?.toDouble() ?? 100.0,
      username: json['username'] as String? ?? 'User',
      email: json['email'] as String? ?? 'user@example.com',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      autoSave: json['autoSave'] as bool? ?? true,
      animationSpeed: (json['animationSpeed'] as num?)?.toDouble() ?? 1.0,
      reducedMotion: json['reducedMotion'] as bool? ?? false,
      dataCompression: json['dataCompression'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    isDarkMode,
    language,
    fontSize,
    primaryColor,
    accentColor,
    notificationsEnabled,
    emailNotifications,
    pushNotifications,
    smsNotifications,
    soundEffects,
    vibration,
    volume,
    biometricAuth,
    pinLock,
    autoLock,
    autoLockTimeout,
    wifiOnlyDownload,
    autoDownloadUpdates,
    maxCacheSize,
    username,
    email,
    avatarUrl,
    autoSave,
    animationSpeed,
    reducedMotion,
    dataCompression,
  ];
}
