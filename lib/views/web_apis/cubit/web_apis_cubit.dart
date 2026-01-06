import 'package:flutter/foundation.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'web_apis_state.dart';
import '../services/web_bluetooth_service.dart';
import '../services/web_authn_service.dart';

/// Web APIs Cubit - Manages Bluetooth and Passkey state with persistence
class WebApisCubit extends BaseViewModelHydratedCubit<WebApisState> {
  final WebBluetoothService _bluetoothService;
  final WebAuthnService _authnService;

  WebApisCubit({
    WebBluetoothService? bluetoothService,
    WebAuthnService? authnService,
  }) : _bluetoothService = bluetoothService ?? WebBluetoothService(),
       _authnService = authnService ?? WebAuthnService(),
       super(const WebApisState()) {
    _checkApiSupport();
  }

  /// Check if Web APIs are supported
  void _checkApiSupport() {
    final bluetoothEnabled = _bluetoothService.isSupported;
    final passkeyEnabled = _authnService.isSupported;

    debugPrint('🔍 Web API Support:');
    debugPrint('  Bluetooth: ${bluetoothEnabled ? "✅" : "❌"}');
    debugPrint('  Passkeys: ${passkeyEnabled ? "✅" : "❌"}');

    stateChanger(
      state.copyWith(
        bluetoothEnabled: bluetoothEnabled,
        passkeyEnabled: passkeyEnabled,
      ),
    );
  }

  /// Re-check API support (call this after state restoration)
  void recheckApiSupport() {
    _checkApiSupport();
  }

  // ==================== BLUETOOTH METHODS ====================

  /// Scan for Bluetooth devices
  Future<void> scanForDevices() async {
    if (!state.bluetoothEnabled) {
      emit(
        state.copyWith(
          scanError: 'Web Bluetooth API is not supported in this browser',
        ),
      );
      return;
    }

    emit(state.copyWith(isScanning: true, scanError: null));

    try {
      debugPrint('🔍 Starting Bluetooth scan...');
      final device = await _bluetoothService.requestDevice();

      if (device != null) {
        // Add device to list if not already present
        final existingIndex = state.bluetoothDevices.indexWhere(
          (d) => d.id == device.id,
        );

        List<BluetoothDevice> updatedDevices;
        if (existingIndex >= 0) {
          updatedDevices = List.from(state.bluetoothDevices);
          updatedDevices[existingIndex] = device;
        } else {
          updatedDevices = [...state.bluetoothDevices, device];
        }

        emit(
          state.copyWith(
            bluetoothDevices: updatedDevices,
            isScanning: false,
            scanError: null,
          ),
        );

        debugPrint('✅ Device added to list: ${device.name}');
      } else {
        emit(state.copyWith(isScanning: false));
      }
    } catch (e) {
      debugPrint('❌ Bluetooth scan error: $e');
      emit(state.copyWith(isScanning: false, scanError: e.toString()));
    }
  }

  /// Connect to a Bluetooth device
  Future<void> connectDevice(String deviceId) async {
    try {
      debugPrint('🔗 Connecting to device: $deviceId');
      final success = await _bluetoothService.connectDevice(deviceId);

      if (success) {
        final deviceIndex = state.bluetoothDevices.indexWhere(
          (d) => d.id == deviceId,
        );

        if (deviceIndex >= 0) {
          final updatedDevices = List<BluetoothDevice>.from(
            state.bluetoothDevices,
          );
          updatedDevices[deviceIndex] = updatedDevices[deviceIndex].copyWith(
            connected: true,
            lastSeen: DateTime.now(),
          );

          emit(state.copyWith(bluetoothDevices: updatedDevices));
          debugPrint('✅ Device connected successfully');
        }
      }
    } catch (e) {
      debugPrint('❌ Connection error: $e');
      emit(state.copyWith(scanError: 'Failed to connect: $e'));
    }
  }

  /// Disconnect from a Bluetooth device
  Future<void> disconnectDevice(String deviceId) async {
    try {
      debugPrint('🔌 Disconnecting from device: $deviceId');
      final success = await _bluetoothService.disconnectDevice(deviceId);

      if (success) {
        final deviceIndex = state.bluetoothDevices.indexWhere(
          (d) => d.id == deviceId,
        );

        if (deviceIndex >= 0) {
          final updatedDevices = List<BluetoothDevice>.from(
            state.bluetoothDevices,
          );
          updatedDevices[deviceIndex] = updatedDevices[deviceIndex].copyWith(
            connected: false,
            lastSeen: DateTime.now(),
          );

          emit(state.copyWith(bluetoothDevices: updatedDevices));
          debugPrint('✅ Device disconnected successfully');
        }
      }
    } catch (e) {
      debugPrint('❌ Disconnection error: $e');
    }
  }

  /// Remove a device from the list
  void removeDevice(String deviceId) {
    final updatedDevices = state.bluetoothDevices
        .where((d) => d.id != deviceId)
        .toList();

    emit(state.copyWith(bluetoothDevices: updatedDevices));
    debugPrint('🗑️ Device removed: $deviceId');
  }

  /// Clear all devices
  void clearDevices() {
    emit(state.copyWith(bluetoothDevices: []));
    debugPrint('🗑️ All devices cleared');
  }

  /// Clear scan error
  void clearScanError() {
    emit(state.copyWith(scanError: null));
  }

  // ==================== PASSKEY METHODS ====================

  /// Create a new passkey
  Future<void> createPasskey({
    required String username,
    String? displayName,
  }) async {
    if (!state.passkeyEnabled) {
      emit(
        state.copyWith(
          authError: 'WebAuthn API is not supported in this browser',
        ),
      );
      return;
    }

    emit(state.copyWith(isAuthenticating: true, authError: null));

    try {
      debugPrint('🔐 Creating passkey for: $username');
      final credential = await _authnService.createCredential(
        username: username,
        displayName: displayName,
      );

      if (credential != null) {
        // Add passkey to list if not already present
        final existingIndex = state.passkeys.indexWhere(
          (p) => p.id == credential.id,
        );

        List<PasskeyCredential> updatedPasskeys;
        if (existingIndex >= 0) {
          updatedPasskeys = List.from(state.passkeys);
          updatedPasskeys[existingIndex] = credential;
        } else {
          updatedPasskeys = [...state.passkeys, credential];
        }

        emit(
          state.copyWith(
            passkeys: updatedPasskeys,
            isAuthenticating: false,
            authError: null,
            lastSuccessfulAuth: username,
          ),
        );

        debugPrint('✅ Passkey created successfully');
      } else {
        emit(state.copyWith(isAuthenticating: false));
      }
    } catch (e) {
      debugPrint('❌ Passkey creation error: $e');
      emit(state.copyWith(isAuthenticating: false, authError: e.toString()));
    }
  }

  /// Authenticate with an existing passkey
  Future<void> authenticateWithPasskey() async {
    if (!state.passkeyEnabled) {
      emit(
        state.copyWith(
          authError: 'WebAuthn API is not supported in this browser',
        ),
      );
      return;
    }

    emit(state.copyWith(isAuthenticating: true, authError: null));

    try {
      debugPrint('🔓 Authenticating with passkey...');
      final credential = await _authnService.authenticate();

      if (credential != null) {
        // Update last used time for the credential
        final existingIndex = state.passkeys.indexWhere(
          (p) => p.id == credential.id,
        );

        List<PasskeyCredential> updatedPasskeys = List.from(state.passkeys);
        if (existingIndex >= 0) {
          updatedPasskeys[existingIndex] = updatedPasskeys[existingIndex]
              .copyWith(lastUsed: DateTime.now());
        }

        emit(
          state.copyWith(
            passkeys: updatedPasskeys,
            isAuthenticating: false,
            authError: null,
            lastSuccessfulAuth: credential.username,
          ),
        );

        debugPrint('✅ Authentication successful');
      } else {
        emit(state.copyWith(isAuthenticating: false));
      }
    } catch (e) {
      debugPrint('❌ Authentication error: $e');
      emit(state.copyWith(isAuthenticating: false, authError: e.toString()));
    }
  }

  /// Remove a passkey from the list
  void removePasskey(String passkeyId) {
    final updatedPasskeys = state.passkeys
        .where((p) => p.id != passkeyId)
        .toList();

    emit(state.copyWith(passkeys: updatedPasskeys));
    debugPrint('🗑️ Passkey removed: $passkeyId');
  }

  /// Clear all passkeys
  void clearPasskeys() {
    emit(state.copyWith(passkeys: []));
    debugPrint('🗑️ All passkeys cleared');
  }

  /// Clear authentication error
  void clearAuthError() {
    emit(state.copyWith(authError: null));
  }

  // ==================== HYDRATED BLOC ====================

  @override
  WebApisState? fromJson(Map<String, dynamic> json) {
    try {
      return WebApisState.fromJson(json);
    } catch (e) {
      debugPrint('❌ Error loading persisted state: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WebApisState state) {
    try {
      return state.toJson();
    } catch (e) {
      debugPrint('❌ Error persisting state: $e');
      return null;
    }
  }
}
