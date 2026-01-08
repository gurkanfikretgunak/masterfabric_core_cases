import 'package:equatable/equatable.dart';

/// State for the BottomSheet test view
class BottomSheetTestState extends Equatable {
  /// Last action result from any bottom sheet
  final String? lastResult;

  /// Last selected value from selection sheet
  final dynamic lastSelection;

  /// Last form data submitted
  final Map<String, dynamic>? lastFormData;

  /// Whether the state is loading
  final bool isLoading;

  const BottomSheetTestState({
    this.lastResult,
    this.lastSelection,
    this.lastFormData,
    this.isLoading = false,
  });

  BottomSheetTestState copyWith({
    String? lastResult,
    dynamic lastSelection,
    Map<String, dynamic>? lastFormData,
    bool? isLoading,
  }) {
    return BottomSheetTestState(
      lastResult: lastResult ?? this.lastResult,
      lastSelection: lastSelection ?? this.lastSelection,
      lastFormData: lastFormData ?? this.lastFormData,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Clear all results
  BottomSheetTestState clearResults() {
    return const BottomSheetTestState();
  }

  @override
  List<Object?> get props => [lastResult, lastSelection, lastFormData, isLoading];
}
