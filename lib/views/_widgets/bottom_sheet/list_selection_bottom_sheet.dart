import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Represents a selectable item in the list
class SelectionItem<T> {
  /// The actual value
  final T value;

  /// Display label
  final String label;

  /// Optional subtitle
  final String? subtitle;

  /// Optional leading icon
  final IconData? icon;

  /// Optional leading widget (overrides icon)
  final Widget? leading;

  /// Whether this item is disabled
  final bool disabled;

  const SelectionItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.leading,
    this.disabled = false,
  });
}

/// List selection bottom sheet for single or multiple selection
/// 
/// For single selection, returns the selected value or null
/// For multiple selection, returns a list of selected values or null
class ListSelectionBottomSheet<T> extends StatefulWidget {
  /// Optional title
  final String? title;

  /// Optional header icon
  final IconData? icon;

  /// List of selectable items
  final List<SelectionItem<T>> items;

  /// Whether to allow multiple selection
  final bool multiSelect;

  /// Initially selected value(s)
  final dynamic initialValue;

  /// Whether to show search field
  final bool searchable;

  /// Search hint text
  final String searchHint;

  /// Confirm button text (for multi-select)
  final String confirmText;

  /// Configuration
  final BottomSheetConfig config;

  /// Whether to show item count in multi-select
  final bool showSelectedCount;

  const ListSelectionBottomSheet({
    super.key,
    this.title,
    this.icon,
    required this.items,
    this.multiSelect = false,
    this.initialValue,
    this.searchable = false,
    this.searchHint = 'Search...',
    this.confirmText = 'Confirm',
    this.config = const BottomSheetConfig(),
    this.showSelectedCount = true,
  });

  /// Show the bottom sheet and return selected value(s)
  static Future<T?> showSingle<T>({
    required BuildContext context,
    String? title,
    IconData? icon,
    required List<SelectionItem<T>> items,
    T? initialValue,
    bool searchable = false,
    String searchHint = 'Search...',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: config.isDismissible,
      enableDrag: config.enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ListSelectionBottomSheet<T>(
        title: title,
        icon: icon,
        items: items,
        multiSelect: false,
        initialValue: initialValue,
        searchable: searchable,
        searchHint: searchHint,
        config: config,
      ),
    );
  }

  /// Show the bottom sheet for multi-selection
  static Future<List<T>?> showMultiple<T>({
    required BuildContext context,
    String? title,
    IconData? icon,
    required List<SelectionItem<T>> items,
    List<T>? initialValues,
    bool searchable = false,
    String searchHint = 'Search...',
    String confirmText = 'Confirm',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      isDismissible: config.isDismissible,
      enableDrag: config.enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ListSelectionBottomSheet<T>(
        title: title,
        icon: icon,
        items: items,
        multiSelect: true,
        initialValue: initialValues,
        searchable: searchable,
        searchHint: searchHint,
        confirmText: confirmText,
        config: config,
      ),
    );
  }

  @override
  State<ListSelectionBottomSheet<T>> createState() => _ListSelectionBottomSheetState<T>();
}

class _ListSelectionBottomSheetState<T> extends State<ListSelectionBottomSheet<T>> {
  late Set<T> _selectedValues;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.multiSelect) {
      _selectedValues = Set<T>.from(widget.initialValue as List<T>? ?? []);
    } else {
      _selectedValues = widget.initialValue != null ? {widget.initialValue as T} : {};
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SelectionItem<T>> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items.where((item) {
      return item.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  void _onItemTap(SelectionItem<T> item) {
    if (item.disabled) return;

    if (widget.multiSelect) {
      setState(() {
        if (_selectedValues.contains(item.value)) {
          _selectedValues.remove(item.value);
        } else {
          _selectedValues.add(item.value);
        }
      });
    } else {
      Navigator.of(context).pop(item.value);
    }
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedValues.toList());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final backgroundColor = widget.config.backgroundColor ?? 
        (isDark ? AppColors.dark.card : AppColors.light.card);
    final borderRadius = widget.config.borderRadius ?? 
        const BorderRadius.vertical(top: Radius.circular(20));
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Container(
      constraints: widget.config.maxHeightFraction != null
          ? BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * widget.config.maxHeightFraction!,
            )
          : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            if (widget.config.showDragHandle)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.3) 
                        : Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            // Header
            if (widget.title != null || widget.icon != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.config.padding.left,
                  0,
                  widget.config.padding.right,
                  16,
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(kRadius),
                        ),
                        child: Icon(
                          widget.icon,
                          color: context.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (widget.title != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            if (widget.multiSelect && widget.showSelectedCount)
                              Text(
                                '${_selectedValues.length} selected',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            // Search field
            if (widget.searchable)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.config.padding.left,
                  0,
                  widget.config.padding.right,
                  12,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
                    prefixIcon: Icon(LucideIcons.search, color: textSecondary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(LucideIcons.x, color: textSecondary, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                      borderSide: BorderSide(
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.1) 
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                      borderSide: BorderSide(
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.1) 
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                      borderSide: BorderSide(color: context.primaryColor, width: 1.5),
                    ),
                    filled: true,
                    fillColor: isDark 
                        ? Colors.white.withValues(alpha: 0.05) 
                        : Colors.black.withValues(alpha: 0.02),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            // Items list
            Flexible(
              child: _filteredItems.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 48,
                            color: textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No items found',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.config.padding.left,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildItem(context, item);
                      },
                    ),
            ),
            // Confirm button for multi-select
            if (widget.multiSelect)
              Padding(
                padding: widget.config.padding,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadius),
                      ),
                    ),
                    child: Text(
                      widget.confirmText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, SelectionItem<T> item) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final isSelected = _selectedValues.contains(item.value);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.disabled ? null : () => _onItemTap(item),
        borderRadius: BorderRadius.circular(kRadius),
        child: Opacity(
          opacity: item.disabled ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: isDark ? 0.15 : 0.08)
                  : null,
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Row(
              children: [
                // Leading
                if (item.leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: item.leading,
                  )
                else if (item.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.primaryColor.withValues(alpha: 0.2)
                            : (isDark 
                                ? Colors.white.withValues(alpha: 0.1) 
                                : Colors.black.withValues(alpha: 0.05)),
                        borderRadius: BorderRadius.circular(kRadius - 2),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: isSelected ? context.primaryColor : textSecondary,
                      ),
                    ),
                  ),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      if (item.subtitle != null)
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                // Selection indicator
                if (widget.multiSelect)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? context.primaryColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected 
                            ? context.primaryColor 
                            : (isDark 
                                ? Colors.white.withValues(alpha: 0.3) 
                                : Colors.black.withValues(alpha: 0.2)),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isSelected
                        ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                        : null,
                  )
                else if (isSelected)
                  Icon(
                    LucideIcons.check,
                    size: 20,
                    color: context.primaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
