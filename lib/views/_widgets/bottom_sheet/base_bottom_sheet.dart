import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Abstract base class for all bottom sheet variants
/// 
/// Type parameter [T] represents the return type when the sheet is closed
abstract class BaseBottomSheet<T> {
  /// Optional title displayed in the header
  final String? title;

  /// Optional icon displayed next to the title
  final IconData? icon;

  /// Configuration for appearance and behavior
  final BottomSheetConfig config;

  const BaseBottomSheet({
    this.title,
    this.icon,
    this.config = const BottomSheetConfig(),
  });

  /// Build the header section of the bottom sheet
  /// Override to customize the header
  Widget buildHeader(BuildContext context) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;

    if (title == null && icon == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Icon(
                icon,
                color: context.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build the main content of the bottom sheet
  /// Must be implemented by subclasses
  Widget buildContent(BuildContext context);

  /// Build the action buttons section
  /// Must be implemented by subclasses
  Widget buildActions(BuildContext context);

  /// Build the drag handle widget
  Widget buildDragHandle(BuildContext context) {
    if (!config.showDragHandle) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDarkMode;
    
    return Center(
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
    );
  }

  /// Build the complete bottom sheet widget
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final backgroundColor = config.backgroundColor ?? 
        (isDark ? AppColors.dark.card : AppColors.light.card);
    final borderRadius = config.borderRadius ?? 
        const BorderRadius.vertical(top: Radius.circular(20));

    return Container(
      constraints: config.maxHeightFraction != null
          ? BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * config.maxHeightFraction!,
            )
          : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: config.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: config.elevation,
                  offset: Offset(0, -config.elevation / 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDragHandle(context),
            Flexible(
              child: SingleChildScrollView(
                padding: config.padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(context),
                    buildContent(context),
                    const SizedBox(height: 20),
                    buildActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the bottom sheet and return a result
  Future<T?> show(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: config.isDismissible,
      enableDrag: config.enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionAnimationController: AnimationController(
        duration: config.animationDuration,
        vsync: Navigator.of(context),
      ),
      builder: (context) => build(context),
    );
  }
}

/// Mixin for bottom sheets that need a close button
mixin CloseButtonMixin<T> on BaseBottomSheet<T> {
  @override
  Widget buildHeader(BuildContext context) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final iconColor = isDark ? AppColors.dark.icon : AppColors.light.icon;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Icon(
                icon,
                color: context.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: iconColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
