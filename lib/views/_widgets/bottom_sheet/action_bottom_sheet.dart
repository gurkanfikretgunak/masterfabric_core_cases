import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/base_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Represents an action in the action sheet
class BottomSheetAction {
  /// Unique identifier for this action
  final String id;

  /// Display label
  final String label;

  /// Optional icon
  final IconData? icon;

  /// Whether this is a destructive action (red color)
  final bool isDestructive;

  /// Whether this action is disabled
  final bool disabled;

  /// Optional subtitle
  final String? subtitle;

  /// Optional custom color
  final Color? color;

  const BottomSheetAction({
    required this.id,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.disabled = false,
    this.subtitle,
    this.color,
  });
}

/// Action bottom sheet for displaying a list of actions
/// 
/// Returns the id of the selected action, or null if cancelled
class ActionBottomSheet extends BaseBottomSheet<String> {
  /// List of actions to display
  final List<BottomSheetAction> actions;

  /// Whether to show a cancel button
  final bool showCancel;

  /// Cancel button text
  final String cancelText;

  /// Whether to show dividers between actions
  final bool showDividers;

  const ActionBottomSheet({
    super.title,
    super.icon,
    required this.actions,
    this.showCancel = true,
    this.cancelText = 'Cancel',
    this.showDividers = false,
    super.config,
  });

  @override
  Widget buildContent(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionTile(context, action),
              if (showDividers && index < actions.length - 1)
                Divider(
                  height: 1,
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.1) 
                      : Colors.black.withValues(alpha: 0.05),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, BottomSheetAction action) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    final effectiveColor = action.color ?? 
        (action.isDestructive ? AppColors.error : textPrimary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.disabled ? null : () => Navigator.of(context).pop(action.id),
        borderRadius: BorderRadius.circular(kRadius),
        child: Opacity(
          opacity: action.disabled ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
            child: Row(
              children: [
                if (action.icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: effectiveColor.withValues(alpha: isDark ? 0.15 : 0.1),
                      borderRadius: BorderRadius.circular(kRadius),
                    ),
                    child: Icon(
                      action.icon,
                      color: effectiveColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.label,
                        style: TextStyle(
                          color: effectiveColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (action.subtitle != null)
                        Text(
                          action.subtitle!,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: textSecondary.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    if (!showCancel) return const SizedBox.shrink();

    final isDark = context.isDarkMode;

    return Column(
      children: [
        Divider(
          height: 24,
          color: isDark 
              ? Colors.white.withValues(alpha: 0.1) 
              : Colors.black.withValues(alpha: 0.05),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
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
      ],
    );
  }

  /// Convenience factory for share actions
  factory ActionBottomSheet.share({
    String? title,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet(
      title: title ?? 'Share',
      icon: LucideIcons.share2,
      actions: const [
        BottomSheetAction(
          id: 'copy_link',
          label: 'Copy Link',
          icon: LucideIcons.link,
        ),
        BottomSheetAction(
          id: 'share_email',
          label: 'Email',
          icon: LucideIcons.mail,
        ),
        BottomSheetAction(
          id: 'share_message',
          label: 'Message',
          icon: LucideIcons.messageSquare,
        ),
        BottomSheetAction(
          id: 'more_options',
          label: 'More Options',
          icon: LucideIcons.ellipsis,
        ),
      ],
      config: config,
    );
  }

  /// Convenience factory for edit/delete actions
  factory ActionBottomSheet.editDelete({
    String? title,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet(
      title: title ?? 'Options',
      actions: const [
        BottomSheetAction(
          id: 'edit',
          label: 'Edit',
          icon: LucideIcons.pencil,
        ),
        BottomSheetAction(
          id: 'delete',
          label: 'Delete',
          icon: LucideIcons.trash2,
          isDestructive: true,
        ),
      ],
      config: config,
    );
  }

  /// Convenience factory for image picker actions
  factory ActionBottomSheet.imagePicker({
    String? title,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet(
      title: title ?? 'Choose Image',
      icon: LucideIcons.image,
      actions: const [
        BottomSheetAction(
          id: 'camera',
          label: 'Take Photo',
          icon: LucideIcons.camera,
        ),
        BottomSheetAction(
          id: 'gallery',
          label: 'Choose from Gallery',
          icon: LucideIcons.images,
        ),
        BottomSheetAction(
          id: 'file',
          label: 'Choose File',
          icon: LucideIcons.file,
        ),
      ],
      config: config,
    );
  }
}
