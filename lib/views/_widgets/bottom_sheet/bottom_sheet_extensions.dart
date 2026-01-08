import 'package:flutter/material.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/confirmation_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/form_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/list_selection_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/action_bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/info_bottom_sheet.dart';

/// Extension on BuildContext for convenient bottom sheet access
extension BottomSheetExtensions on BuildContext {
  // ============================================
  // CONFIRMATION SHEETS
  // ============================================

  /// Show a confirmation dialog
  /// Returns true if confirmed, false if cancelled
  Future<bool> showConfirmation({
    String? title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    ConfirmationType type = ConfirmationType.normal,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showIcon = true,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) async {
    final result = await ConfirmationBottomSheet(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      type: type,
      onConfirm: onConfirm,
      onCancel: onCancel,
      showIcon: showIcon,
      config: config,
    ).show(this);
    return result ?? false;
  }

  /// Show a delete confirmation dialog
  Future<bool> showDeleteConfirmation({
    String? title,
    String? message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) async {
    final result = await ConfirmationBottomSheet.delete(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      config: config,
    ).show(this);
    return result ?? false;
  }

  /// Show a warning confirmation dialog
  Future<bool> showWarningConfirmation({
    String? title,
    required String message,
    String confirmText = 'Continue',
    String cancelText = 'Cancel',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) async {
    final result = await ConfirmationBottomSheet.warning(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      config: config,
    ).show(this);
    return result ?? false;
  }

  // ============================================
  // FORM SHEETS
  // ============================================

  /// Show a form bottom sheet
  /// Returns the transformed result if submitted, null if cancelled
  Future<T?> showFormSheet<T>({
    String? title,
    IconData? icon,
    required List<FormFieldConfig> fields,
    String submitText = 'Submit',
    String cancelText = 'Cancel',
    bool showCancel = true,
    required T Function(Map<String, dynamic> data) onSubmit,
    String? Function(Map<String, dynamic>)? formValidator,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return FormBottomSheet<T>(
      title: title,
      icon: icon,
      fields: fields,
      submitText: submitText,
      cancelText: cancelText,
      showCancel: showCancel,
      onSubmit: onSubmit,
      formValidator: formValidator,
      config: config,
    ).show(this);
  }

  /// Show a simple text input form
  Future<String?> showTextInput({
    String? title,
    IconData? icon,
    String fieldLabel = 'Enter text',
    String? fieldHint,
    String? initialValue,
    bool required = true,
    String submitText = 'Submit',
    String cancelText = 'Cancel',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return showFormSheet<String>(
      title: title,
      icon: icon,
      fields: [
        FormFieldConfig.text(
          name: 'text',
          label: fieldLabel,
          hint: fieldHint,
          initialValue: initialValue,
          required: required,
        ),
      ],
      submitText: submitText,
      cancelText: cancelText,
      onSubmit: (data) => data['text'] as String,
      config: config,
    );
  }

  // ============================================
  // SELECTION SHEETS
  // ============================================

  /// Show a single selection list
  Future<T?> showSingleSelection<T>({
    String? title,
    IconData? icon,
    required List<SelectionItem<T>> items,
    T? initialValue,
    bool searchable = false,
    String searchHint = 'Search...',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ListSelectionBottomSheet.showSingle<T>(
      context: this,
      title: title,
      icon: icon,
      items: items,
      initialValue: initialValue,
      searchable: searchable,
      searchHint: searchHint,
      config: config,
    );
  }

  /// Show a multi-selection list
  Future<List<T>?> showMultiSelection<T>({
    String? title,
    IconData? icon,
    required List<SelectionItem<T>> items,
    List<T>? initialValues,
    bool searchable = false,
    String searchHint = 'Search...',
    String confirmText = 'Confirm',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ListSelectionBottomSheet.showMultiple<T>(
      context: this,
      title: title,
      icon: icon,
      items: items,
      initialValues: initialValues,
      searchable: searchable,
      searchHint: searchHint,
      confirmText: confirmText,
      config: config,
    );
  }

  // ============================================
  // ACTION SHEETS
  // ============================================

  /// Show an action sheet
  /// Returns the id of the selected action, or null if cancelled
  Future<String?> showActionSheet({
    String? title,
    IconData? icon,
    required List<BottomSheetAction> actions,
    bool showCancel = true,
    String cancelText = 'Cancel',
    bool showDividers = false,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet(
      title: title,
      icon: icon,
      actions: actions,
      showCancel: showCancel,
      cancelText: cancelText,
      showDividers: showDividers,
      config: config,
    ).show(this);
  }

  /// Show a share action sheet
  Future<String?> showShareSheet({
    String? title,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet.share(
      title: title,
      config: config,
    ).show(this);
  }

  /// Show an edit/delete action sheet
  Future<String?> showEditDeleteSheet({
    String? title,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet.editDelete(
      title: title,
      config: config,
    ).show(this);
  }

  /// Show an image picker action sheet
  Future<String?> showImagePickerSheet({
    String? title,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return ActionBottomSheet.imagePicker(
      title: title,
      config: config,
    ).show(this);
  }

  // ============================================
  // INFO SHEETS
  // ============================================

  /// Show an info sheet with custom content
  Future<void> showInfoSheet({
    String? title,
    IconData? icon,
    required Widget content,
    String? actionText,
    VoidCallback? onAction,
    String? closeText = 'Close',
    InfoType type = InfoType.info,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet(
      title: title,
      icon: icon,
      content: content,
      actionText: actionText,
      onAction: onAction,
      closeText: closeText,
      type: type,
      config: config,
    ).show(this);
  }

  /// Show a simple text info sheet
  Future<void> showInfoText({
    String? title,
    IconData? icon,
    required String text,
    InfoType type = InfoType.info,
    String? actionText,
    VoidCallback? onAction,
    String? closeText = 'Close',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.text(
      title: title,
      icon: icon,
      text: text,
      type: type,
      actionText: actionText,
      onAction: onAction,
      closeText: closeText,
      config: config,
    ).show(this);
  }

  /// Show a success info sheet
  Future<void> showSuccessSheet({
    String title = 'Success',
    required String message,
    String closeText = 'Done',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.success(
      title: title,
      message: message,
      closeText: closeText,
      config: config,
    ).show(this);
  }

  /// Show an error info sheet
  Future<void> showErrorSheet({
    String title = 'Error',
    required String message,
    String closeText = 'OK',
    String? retryText,
    VoidCallback? onRetry,
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.error(
      title: title,
      message: message,
      closeText: closeText,
      retryText: retryText,
      onRetry: onRetry,
      config: config,
    ).show(this);
  }

  /// Show a warning info sheet
  Future<void> showWarningSheet({
    String title = 'Warning',
    required String message,
    String closeText = 'OK',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.warning(
      title: title,
      message: message,
      closeText: closeText,
      config: config,
    ).show(this);
  }

  /// Show a help/tips info sheet
  Future<void> showHelpSheet({
    String title = 'Help',
    required String message,
    String closeText = 'Got it',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.help(
      title: title,
      message: message,
      closeText: closeText,
      config: config,
    ).show(this);
  }

  /// Show an about info sheet
  Future<void> showAboutSheet({
    required String appName,
    required String version,
    String? buildNumber,
    Widget? logo,
    String? description,
    String closeText = 'Close',
    BottomSheetConfig config = const BottomSheetConfig(),
  }) {
    return InfoBottomSheet.about(
      appName: appName,
      version: version,
      buildNumber: buildNumber,
      logo: logo,
      description: description,
      closeText: closeText,
      config: config,
    ).show(this);
  }
}
