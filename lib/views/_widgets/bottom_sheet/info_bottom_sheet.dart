import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/base_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Info bottom sheet for displaying read-only content
/// 
/// Returns void when closed
class InfoBottomSheet extends BaseBottomSheet<void> {
  /// The content to display
  final Widget content;

  /// Optional action button text
  final String? actionText;

  /// Optional action callback
  final VoidCallback? onAction;

  /// Optional close button text (if null, no close button shown)
  final String? closeText;

  /// Info type for styling
  final InfoType type;

  const InfoBottomSheet({
    super.title,
    super.icon,
    required this.content,
    this.actionText,
    this.onAction,
    this.closeText = 'Close',
    this.type = InfoType.info,
    super.config,
  });

  @override
  Widget buildHeader(BuildContext context) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final typeColor = type.getColor(context);

    if (title == null && icon == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Icon(
              icon ?? type.icon,
              color: typeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
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
    return content;
  }

  @override
  Widget buildActions(BuildContext context) {
    final isDark = context.isDarkMode;

    if (actionText == null && closeText == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (closeText != null)
          Expanded(
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
                closeText!,
                style: TextStyle(
                  color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (closeText != null && actionText != null)
          const SizedBox(width: 12),
        if (actionText != null)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onAction?.call();
                Navigator.of(context).pop();
              },
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
                actionText!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  /// Factory for simple text info
  factory InfoBottomSheet.text({
    String? title,
    IconData? icon,
    required String text,
    InfoType type = InfoType.info,
    String? actionText,
    VoidCallback? onAction,
    String? closeText = 'Close',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet(
      title: title,
      icon: icon,
      type: type,
      actionText: actionText,
      onAction: onAction,
      closeText: closeText,
      config: config,
      content: Builder(
        builder: (context) {
          final isDark = context.isDarkMode;
          final textSecondary = isDark 
              ? AppColors.dark.textSecondary 
              : AppColors.light.textSecondary;
          return Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textSecondary,
              height: 1.5,
            ),
          );
        },
      ),
    );
  }

  /// Factory for success info
  factory InfoBottomSheet.success({
    String title = 'Success',
    required String message,
    String closeText = 'Done',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.text(
      title: title,
      text: message,
      type: InfoType.success,
      closeText: closeText,
      config: config,
    );
  }

  /// Factory for error info
  factory InfoBottomSheet.error({
    String title = 'Error',
    required String message,
    String closeText = 'OK',
    String? retryText,
    VoidCallback? onRetry,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.text(
      title: title,
      text: message,
      type: InfoType.error,
      closeText: closeText,
      actionText: retryText,
      onAction: onRetry,
      config: config,
    );
  }

  /// Factory for warning info
  factory InfoBottomSheet.warning({
    String title = 'Warning',
    required String message,
    String closeText = 'OK',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.text(
      title: title,
      text: message,
      type: InfoType.warning,
      closeText: closeText,
      config: config,
    );
  }

  /// Factory for help/tips info
  factory InfoBottomSheet.help({
    String title = 'Help',
    required String message,
    String closeText = 'Got it',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.text(
      title: title,
      icon: LucideIcons.circleHelp,
      text: message,
      type: InfoType.info,
      closeText: closeText,
      config: config,
    );
  }

  /// Factory for about info with version
  factory InfoBottomSheet.about({
    required String appName,
    required String version,
    String? buildNumber,
    Widget? logo,
    String? description,
    String closeText = 'Close',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet(
      title: 'About',
      icon: LucideIcons.info,
      type: InfoType.info,
      closeText: closeText,
      config: config,
      content: Builder(
        builder: (context) {
          final isDark = context.isDarkMode;
          final textPrimary = isDark 
              ? AppColors.dark.textPrimary 
              : AppColors.light.textPrimary;
          final textSecondary = isDark 
              ? AppColors.dark.textSecondary 
              : AppColors.light.textSecondary;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logo != null) ...[
                logo,
                const SizedBox(height: 16),
              ],
              Text(
                appName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                buildNumber != null 
                    ? 'Version $version ($buildNumber)'
                    : 'Version $version',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Types of info sheets
enum InfoType {
  info,
  success,
  warning,
  error,
}

extension InfoTypeExtension on InfoType {
  Color getColor(BuildContext context) {
    switch (this) {
      case InfoType.info:
        return context.primaryColor;
      case InfoType.success:
        return AppColors.success;
      case InfoType.warning:
        return AppColors.warning;
      case InfoType.error:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case InfoType.info:
        return LucideIcons.info;
      case InfoType.success:
        return LucideIcons.circleCheck;
      case InfoType.warning:
        return LucideIcons.triangleAlert;
      case InfoType.error:
        return LucideIcons.circleAlert;
    }
  }
}
