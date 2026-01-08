import 'package:masterfabric_core/masterfabric_core.dart';
import 'bottom_sheet_test_state.dart';

/// Cubit for the BottomSheet test view
class BottomSheetTestCubit extends BaseViewModelCubit<BottomSheetTestState> {
  BottomSheetTestCubit() : super(const BottomSheetTestState());

  /// Initialize the view
  Future<void> initialize() async {
    // Nothing to initialize for this demo view
  }

  /// Update the last result
  void setLastResult(String result) {
    emit(state.copyWith(lastResult: result));
  }

  /// Update the last selection
  void setLastSelection(dynamic selection) {
    emit(state.copyWith(lastSelection: selection));
  }

  /// Update the last form data
  void setLastFormData(Map<String, dynamic> data) {
    emit(state.copyWith(lastFormData: data));
  }

  /// Clear all results
  void clearResults() {
    emit(state.clearResults());
  }
}
