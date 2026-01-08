import 'package:equatable/equatable.dart';

/// State for Hive CE feature demonstration
class HiveCeState extends Equatable {
  final bool isLoading;
  final List<String> items;
  final String? error;
  final int itemCount;
  final Map<String, dynamic>? boxInfo;

  const HiveCeState({
    this.isLoading = false,
    this.items = const [],
    this.error,
    this.itemCount = 0,
    this.boxInfo,
  });

  HiveCeState copyWith({
    bool? isLoading,
    List<String>? items,
    String? error,
    int? itemCount,
    Map<String, dynamic>? boxInfo,
  }) {
    return HiveCeState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error,
      itemCount: itemCount ?? this.itemCount,
      boxInfo: boxInfo ?? this.boxInfo,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, error, itemCount, boxInfo];
}

