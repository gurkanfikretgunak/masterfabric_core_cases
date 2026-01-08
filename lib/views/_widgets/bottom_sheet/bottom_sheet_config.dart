import 'package:flutter/material.dart';

/// Configuration model for customizing bottom sheet appearance and behavior
class BottomSheetConfig {
  /// Background color of the bottom sheet
  final Color? backgroundColor;

  /// Border radius for the top corners
  final BorderRadius? borderRadius;

  /// Padding inside the bottom sheet
  final EdgeInsets padding;

  /// Whether to show the drag handle at the top
  final bool showDragHandle;

  /// Maximum height constraint (as fraction of screen height)
  final double? maxHeightFraction;

  /// Animation duration for showing/hiding
  final Duration animationDuration;

  /// Animation curve for transitions
  final Curve animationCurve;

  /// Whether the bottom sheet can be dismissed by tapping outside
  final bool isDismissible;

  /// Whether the bottom sheet can be dragged to dismiss
  final bool enableDrag;

  /// Whether to use safe area padding
  final bool useSafeArea;

  /// Elevation of the bottom sheet
  final double elevation;

  const BottomSheetConfig({
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.all(20),
    this.showDragHandle = true,
    this.maxHeightFraction = 0.9,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.isDismissible = true,
    this.enableDrag = true,
    this.useSafeArea = true,
    this.elevation = 0,
  });

  /// Creates a copy with optional overrides
  BottomSheetConfig copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool? showDragHandle,
    double? maxHeightFraction,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? isDismissible,
    bool? enableDrag,
    bool? useSafeArea,
    double? elevation,
  }) {
    return BottomSheetConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      maxHeightFraction: maxHeightFraction ?? this.maxHeightFraction,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      isDismissible: isDismissible ?? this.isDismissible,
      enableDrag: enableDrag ?? this.enableDrag,
      useSafeArea: useSafeArea ?? this.useSafeArea,
      elevation: elevation ?? this.elevation,
    );
  }

  /// Default configuration
  static const BottomSheetConfig defaults = BottomSheetConfig();

  /// Configuration for non-dismissible sheets
  static const BottomSheetConfig nonDismissible = BottomSheetConfig(
    isDismissible: false,
    enableDrag: false,
  );

  /// Configuration for compact sheets
  static const BottomSheetConfig compact = BottomSheetConfig(
    padding: EdgeInsets.all(16),
    maxHeightFraction: 0.5,
  );

  /// Configuration for full-height sheets
  static const BottomSheetConfig fullHeight = BottomSheetConfig(
    maxHeightFraction: 0.95,
    showDragHandle: false,
  );
}
