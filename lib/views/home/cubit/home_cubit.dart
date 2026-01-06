import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';

part 'home_state.dart';

/// Cubit for Home screen
class HomeCubit extends BaseViewModelCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// Initial loading
  void initialize() {
    emit(state.copyWith(isLoading: false));
  }

  triggerTheSettingLangChange(String lang) {
    // Example operation: Change settings language
    // This method can call the changeLanguage method in SettingsCubit
    final settingsCubit = GetIt.instance<SettingsCubit>();

    settingsCubit.changeLanguage(lang);
  }

  /// Increment counter
  void incrementCounter() {
    emit(state.copyWith(counter: state.counter + 1));
  }
}
