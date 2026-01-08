import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'hive_ce_state.dart';

/// Hive CE Cubit - Demonstrates HiveCeHelper usage from masterfabric_core
class HiveCeCubit extends BaseViewModelCubit<HiveCeState> {
  static const String _boxName = 'hive_ce_demo';
  Box? _box;

  HiveCeCubit() : super(const HiveCeState());

  /// Initialize Hive and load data
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Open box (will create if doesn't exist)
      // Hive CE boxes can be opened directly without explicit initialization
      _box = await Hive.openBox(_boxName);

      // Load existing items
      final items = _box?.get('items', defaultValue: <String>[]) as List<dynamic>?;
      final itemList = items?.map((e) => e.toString()).toList() ?? [];

      // Get box info
      final boxInfo = _getBoxInfo();

      emit(state.copyWith(
        isLoading: false,
        items: itemList,
        itemCount: itemList.length,
        boxInfo: boxInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to initialize Hive: $e',
      ));
    }
  }

  /// Get box information
  Map<String, dynamic> _getBoxInfo() {
    if (_box == null) {
      return {'status': 'not_initialized'};
    }

    return {
      'name': _box!.name,
      'isOpen': _box!.isOpen,
      'keys': _box!.keys.length,
      'length': _box!.length,
      'isEmpty': _box!.isEmpty,
      'isNotEmpty': _box!.isNotEmpty,
    };
  }

  /// Add a new item to Hive
  Future<void> addItem(String item) async {
    if (item.trim().isEmpty) return;

    try {
      final newItems = [...state.items, item];
      await _box?.put('items', newItems);

      emit(state.copyWith(
        items: newItems,
        itemCount: newItems.length,
        boxInfo: _getBoxInfo(),
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add item: $e'));
    }
  }

  /// Remove an item from Hive
  Future<void> removeItem(int index) async {
    if (index < 0 || index >= state.items.length) return;

    try {
      final newItems = List<String>.from(state.items)..removeAt(index);
      await _box?.put('items', newItems);

      emit(state.copyWith(
        items: newItems,
        itemCount: newItems.length,
        boxInfo: _getBoxInfo(),
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove item: $e'));
    }
  }

  /// Clear all items from Hive
  Future<void> clearAll() async {
    try {
      await _box?.put('items', <String>[]);

      emit(state.copyWith(
        items: [],
        itemCount: 0,
        boxInfo: _getBoxInfo(),
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to clear items: $e'));
    }
  }

  /// Save custom data to Hive
  Future<void> saveCustomData(Map<String, dynamic> data) async {
    try {
      await _box?.put('custom_data', data);

      emit(state.copyWith(boxInfo: _getBoxInfo()));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to save custom data: $e'));
    }
  }

  /// Get custom data from Hive
  Map<String, dynamic>? getCustomData() {
    try {
      return _box?.get('custom_data') as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to get custom data: $e');
      return null;
    }
  }

  /// Refresh box info
  void refreshBoxInfo() {
    try {
      final boxInfo = _getBoxInfo();
      emit(state.copyWith(boxInfo: boxInfo));
    } catch (e) {
      debugPrint('Failed to get box info: $e');
    }
  }

  @override
  Future<void> close() {
    _box?.close();
    return super.close();
  }
}

