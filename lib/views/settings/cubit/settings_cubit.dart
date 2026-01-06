import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'package:injectable/injectable.dart';

/// Settings Cubit - Uses HydratedCubit for state persistence
/// State will be automatically saved and restored across app restarts
@injectable
class SettingsCubit extends BaseViewModelHydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  // 🎨 Appearance Methods
  void toggleDarkMode() {
    stateChanger(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void changeLanguage(String language) {
    stateChanger(state.copyWith(language: language));
  }

  void updateFontSize(double fontSize) {
    stateChanger(state.copyWith(fontSize: fontSize));
  }

  void changePrimaryColor(String color) {
    stateChanger(state.copyWith(primaryColor: color));
  }

  void changeAccentColor(String color) {
    stateChanger(state.copyWith(accentColor: color));
  }

  // 🔔 Notification Methods
  void toggleNotifications() {
    stateChanger(
      state.copyWith(notificationsEnabled: !state.notificationsEnabled),
    );
  }

  void toggleEmailNotifications() {
    stateChanger(state.copyWith(emailNotifications: !state.emailNotifications));
  }

  void togglePushNotifications() {
    stateChanger(state.copyWith(pushNotifications: !state.pushNotifications));
  }

  void toggleSmsNotifications() {
    stateChanger(state.copyWith(smsNotifications: !state.smsNotifications));
  }

  // 🎵 Sound & Haptics Methods
  void toggleSoundEffects() {
    stateChanger(state.copyWith(soundEffects: !state.soundEffects));
  }

  void toggleVibration() {
    stateChanger(state.copyWith(vibration: !state.vibration));
  }

  void updateVolume(double volume) {
    stateChanger(state.copyWith(volume: volume));
  }

  // 🔐 Security Methods
  void toggleBiometricAuth() {
    stateChanger(state.copyWith(biometricAuth: !state.biometricAuth));
  }

  void togglePinLock() {
    stateChanger(state.copyWith(pinLock: !state.pinLock));
  }

  void toggleAutoLock() {
    stateChanger(state.copyWith(autoLock: !state.autoLock));
  }

  void updateAutoLockTimeout(int minutes) {
    stateChanger(state.copyWith(autoLockTimeout: minutes));
  }

  // 🌐 Network & Data Methods
  void toggleWifiOnlyDownload() {
    stateChanger(state.copyWith(wifiOnlyDownload: !state.wifiOnlyDownload));
  }

  void toggleAutoDownloadUpdates() {
    stateChanger(
      state.copyWith(autoDownloadUpdates: !state.autoDownloadUpdates),
    );
  }

  void updateMaxCacheSize(double size) {
    stateChanger(state.copyWith(maxCacheSize: size));
  }

  // 👤 Profile Methods
  void updateUsername(String username) {
    stateChanger(state.copyWith(username: username));
  }

  void updateEmail(String email) {
    stateChanger(state.copyWith(email: email));
  }

  void updateAvatarUrl(String url) {
    stateChanger(state.copyWith(avatarUrl: url));
  }

  // ⚡ Performance Methods
  void toggleAutoSave() {
    stateChanger(state.copyWith(autoSave: !state.autoSave));
  }

  void updateAnimationSpeed(double speed) {
    stateChanger(state.copyWith(animationSpeed: speed));
  }

  void toggleReducedMotion() {
    stateChanger(state.copyWith(reducedMotion: !state.reducedMotion));
  }

  void toggleDataCompression() {
    stateChanger(state.copyWith(dataCompression: !state.dataCompression));
  }

  /// Reset to default settings
  void resetToDefaults() {
    stateChanger(const SettingsState());
  }

  /// Serialize state to JSON for HydratedBloc
  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }

  /// Deserialize state from JSON for HydratedBloc
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState.fromJson(json);
    } catch (e) {
      // If deserialization fails, return default state
      return const SettingsState();
    }
  }
}
