import 'package:equatable/equatable.dart';

/// Bluetooth Device Model
class BluetoothDevice extends Equatable {
  final String id;
  final String name;
  final bool connected;
  final DateTime lastSeen;
  final int? rssi;

  const BluetoothDevice({
    required this.id,
    required this.name,
    this.connected = false,
    required this.lastSeen,
    this.rssi,
  });

  factory BluetoothDevice.fromJson(Map<String, dynamic> json) {
    return BluetoothDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      connected: json['connected'] as bool? ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      rssi: json['rssi'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'connected': connected,
      'lastSeen': lastSeen.toIso8601String(),
      'rssi': rssi,
    };
  }

  BluetoothDevice copyWith({
    String? id,
    String? name,
    bool? connected,
    DateTime? lastSeen,
    int? rssi,
  }) {
    return BluetoothDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      connected: connected ?? this.connected,
      lastSeen: lastSeen ?? this.lastSeen,
      rssi: rssi ?? this.rssi,
    );
  }

  @override
  List<Object?> get props => [id, name, connected, lastSeen, rssi];
}

/// Passkey Credential Model
class PasskeyCredential extends Equatable {
  final String id;
  final String username;
  final DateTime createdAt;
  final DateTime lastUsed;
  final String? displayName;

  const PasskeyCredential({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.lastUsed,
    this.displayName,
  });

  factory PasskeyCredential.fromJson(Map<String, dynamic> json) {
    return PasskeyCredential(
      id: json['id'] as String,
      username: json['username'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      displayName: json['displayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
      'displayName': displayName,
    };
  }

  PasskeyCredential copyWith({
    String? id,
    String? username,
    DateTime? createdAt,
    DateTime? lastUsed,
    String? displayName,
  }) {
    return PasskeyCredential(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [id, username, createdAt, lastUsed, displayName];
}

/// Web APIs State
class WebApisState extends Equatable {
  final List<BluetoothDevice> bluetoothDevices;
  final bool isScanning;
  final String? scanError;
  final List<PasskeyCredential> passkeys;
  final bool isAuthenticating;
  final String? authError;
  final bool bluetoothEnabled;
  final bool passkeyEnabled;
  final String? lastSuccessfulAuth;

  const WebApisState({
    this.bluetoothDevices = const [],
    this.isScanning = false,
    this.scanError,
    this.passkeys = const [],
    this.isAuthenticating = false,
    this.authError,
    this.bluetoothEnabled = false,
    this.passkeyEnabled = false,
    this.lastSuccessfulAuth,
  });

  factory WebApisState.fromJson(Map<String, dynamic> json) {
    return WebApisState(
      bluetoothDevices:
          (json['bluetoothDevices'] as List<dynamic>?)
              ?.map((e) => BluetoothDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isScanning: json['isScanning'] as bool? ?? false,
      scanError: json['scanError'] as String?,
      passkeys:
          (json['passkeys'] as List<dynamic>?)
              ?.map(
                (e) => PasskeyCredential.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      isAuthenticating: json['isAuthenticating'] as bool? ?? false,
      authError: json['authError'] as String?,
      bluetoothEnabled: json['bluetoothEnabled'] as bool? ?? false,
      passkeyEnabled: json['passkeyEnabled'] as bool? ?? false,
      lastSuccessfulAuth: json['lastSuccessfulAuth'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bluetoothDevices': bluetoothDevices.map((e) => e.toJson()).toList(),
      'isScanning': isScanning,
      'scanError': scanError,
      'passkeys': passkeys.map((e) => e.toJson()).toList(),
      'isAuthenticating': isAuthenticating,
      'authError': authError,
      'bluetoothEnabled': bluetoothEnabled,
      'passkeyEnabled': passkeyEnabled,
      'lastSuccessfulAuth': lastSuccessfulAuth,
    };
  }

  WebApisState copyWith({
    List<BluetoothDevice>? bluetoothDevices,
    bool? isScanning,
    String? scanError,
    List<PasskeyCredential>? passkeys,
    bool? isAuthenticating,
    String? authError,
    bool? bluetoothEnabled,
    bool? passkeyEnabled,
    String? lastSuccessfulAuth,
  }) {
    return WebApisState(
      bluetoothDevices: bluetoothDevices ?? this.bluetoothDevices,
      isScanning: isScanning ?? this.isScanning,
      scanError: scanError ?? this.scanError,
      passkeys: passkeys ?? this.passkeys,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      authError: authError ?? this.authError,
      bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
      passkeyEnabled: passkeyEnabled ?? this.passkeyEnabled,
      lastSuccessfulAuth: lastSuccessfulAuth ?? this.lastSuccessfulAuth,
    );
  }

  @override
  List<Object?> get props => [
    bluetoothDevices,
    isScanning,
    scanError,
    passkeys,
    isAuthenticating,
    authError,
    bluetoothEnabled,
    passkeyEnabled,
    lastSuccessfulAuth,
  ];

  @override
  String toString() {
    return 'WebApisState(devices: ${bluetoothDevices.length}, scanning: $isScanning, passkeys: ${passkeys.length}, auth: $isAuthenticating)';
  }
}
