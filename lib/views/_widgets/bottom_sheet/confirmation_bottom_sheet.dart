import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/base_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Types of confirmation dialogs with different visual styles
enum ConfirmationType {
  /// Standard confirmation (primary color)
  normal,

  /// Warning confirmation (orange/amber)
  warning,

  /// Danger/destructive confirmation (red)
  danger,

  /// Success confirmation (green)
  success,
}

/// Extension to get colors and icons for confirmation types
extension ConfirmationTypeExtension on ConfirmationType {
  Color getColor(BuildContext context) {
    switch (this) {
      case ConfirmationType.normal:
        return context.primaryColor;
      case ConfirmationType.warning:
        return AppColors.warning;
      case ConfirmationType.danger:
        return AppColors.error;
      case ConfirmationType.success:
        return AppColors.success;
    }
  }

  IconData get icon {
    switch (this) {
      case ConfirmationType.normal:
        return LucideIcons.circleHelp;
      case ConfirmationType.warning:
        return LucideIcons.triangleAlert;
      case ConfirmationType.danger:
        return LucideIcons.circleAlert;
      case ConfirmationType.success:
        return LucideIcons.circleCheck;
    }
  }
}

/// Confirmation bottom sheet for Yes/No dialogs
/// 
/// Returns `true` if confirmed, `false` if cancelled
class ConfirmationBottomSheet extends BaseBottomSheet<bool> {
  /// The confirmation message to display
  final String message;

  /// Text for the confirm button
  final String confirmText;

  /// Text for the cancel button
  final String cancelText;

  /// Type of confirmation (affects colors and icon)
  final ConfirmationType type;

  /// Optional callback when confirmed
  final VoidCallback? onConfirm;

  /// Optional callback when cancelled
  final VoidCallback? onCancel;

  /// Whether to show the type icon in header
  final bool showIcon;

  const ConfirmationBottomSheet({
    super.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.type = ConfirmationType.normal,
    this.onConfirm,
    this.onCancel,
    this.showIcon = true,
    super.config,
  }) : super(icon: null);

  @override
  Widget buildHeader(BuildContext context) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final typeColor = type.getColor(context);

    if (title == null && !showIcon) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          if (showIcon) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Icon(
                type.icon,
                color: typeColor,
                size: 22,
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

  @override
  Widget buildContent(BuildContext context) {
    final isDark = context.isDarkMode;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Text(
      message,
      style: TextStyle(
        fontSize: 15,
        color: textSecondary,
        height: 1.5,
      ),
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    final isDark = context.isDarkMode;
    final typeColor = type.getColor(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.2) 
                    : Colors.black.withValues(alpha: 0.1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
            ),
            child: Text(
              cancelText,
              style: TextStyle(
                color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: typeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Convenience factory for delete confirmations
  factory ConfirmationBottomSheet.delete({
    String? title,
    String? message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ConfirmationBottomSheet(
      title: title ?? 'Delete Item',
      message: message ?? 'Are you sure you want to delete this item? This action cannot be undone.',
      confirmText: confirmText,
      cancelText: cancelText,
      type: ConfirmationType.danger,
      onConfirm: onConfirm,
      onCancel: onCancel,
      config: config,
    );
  }

  /// Convenience factory for warning confirmations
  factory ConfirmationBottomSheet.warning({
    String? title,
    required String message,
    String confirmText = 'Continue',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ConfirmationBottomSheet(
      title: title ?? 'Warning',
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      type: ConfirmationType.warning,
      onConfirm: onConfirm,
      onCancel: onCancel,
      config: config,
    );
  }

  /// Convenience factory for success confirmations
  factory ConfirmationBottomSheet.success({
    String? title,
    required String message,
    String confirmText = 'Done',
    String cancelText = 'Close',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ConfirmationBottomSheet(
      title: title ?? 'Success',
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      type: ConfirmationType.success,
      onConfirm: onConfirm,
      onCancel: onCancel,
      config: config,
    );
  }
}
