import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet_config.dart';

/// Field types for form configuration
enum FormFieldType {
  text,
  email,
  password,
  number,
  phone,
  multiline,
}

/// Configuration for a single form field
class FormFieldConfig {
  /// Unique name/key for this field
  final String name;

  /// Display label
  final String label;

  /// Placeholder hint text
  final String? hint;

  /// Field type
  final FormFieldType type;

  /// Initial value
  final String? initialValue;

  /// Whether the field is required
  final bool required;

  /// Custom validator function
  final String? Function(String?)? validator;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Maximum lines for multiline fields
  final int maxLines;

  /// Maximum length
  final int? maxLength;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  const FormFieldConfig({
    required this.name,
    required this.label,
    this.hint,
    this.type = FormFieldType.text,
    this.initialValue,
    this.required = false,
    this.validator,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
  });

  /// Factory for text field
  factory FormFieldConfig.text({
    required String name,
    required String label,
    String? hint,
    String? initialValue,
    bool required = false,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    int? maxLength,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint,
      type: FormFieldType.text,
      initialValue: initialValue,
      required: required,
      validator: validator,
      prefixIcon: prefixIcon,
      maxLength: maxLength,
    );
  }

  /// Factory for email field
  factory FormFieldConfig.email({
    required String name,
    String label = 'Email',
    String? hint,
    String? initialValue,
    bool required = true,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint ?? 'Enter your email',
      type: FormFieldType.email,
      initialValue: initialValue,
      required: required,
      prefixIcon: LucideIcons.mail,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return required ? 'Email is required' : null;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  /// Factory for password field
  factory FormFieldConfig.password({
    required String name,
    String label = 'Password',
    String? hint,
    bool required = true,
    int? minLength,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint ?? 'Enter your password',
      type: FormFieldType.password,
      required: required,
      prefixIcon: LucideIcons.lock,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return required ? 'Password is required' : null;
        }
        if (minLength != null && value.length < minLength) {
          return 'Password must be at least $minLength characters';
        }
        return null;
      },
    );
  }

  /// Factory for number field
  factory FormFieldConfig.number({
    required String name,
    required String label,
    String? hint,
    String? initialValue,
    bool required = false,
    IconData? prefixIcon,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint,
      type: FormFieldType.number,
      initialValue: initialValue,
      required: required,
      prefixIcon: prefixIcon,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  /// Factory for phone field
  factory FormFieldConfig.phone({
    required String name,
    String label = 'Phone',
    String? hint,
    String? initialValue,
    bool required = false,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint ?? 'Enter phone number',
      type: FormFieldType.phone,
      initialValue: initialValue,
      required: required,
      prefixIcon: LucideIcons.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  /// Factory for multiline text field
  factory FormFieldConfig.multiline({
    required String name,
    required String label,
    String? hint,
    String? initialValue,
    bool required = false,
    int maxLines = 4,
    int? maxLength,
  }) {
    return FormFieldConfig(
      name: name,
      label: label,
      hint: hint,
      type: FormFieldType.multiline,
      initialValue: initialValue,
      required: required,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }

  /// Get keyboard type based on field type
  TextInputType get keyboardType {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.password:
        return TextInputType.visiblePassword;
      case FormFieldType.number:
        return TextInputType.number;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.multiline:
        return TextInputType.multiline;
      case FormFieldType.text:
        return TextInputType.text;
    }
  }
}

/// Form bottom sheet for collecting user input
/// 
/// Returns a Map<String, dynamic> with field values if submitted, null if cancelled
class FormBottomSheet<T> {
  /// Optional title
  final String? title;

  /// Optional icon
  final IconData? icon;

  /// Configuration
  final BottomSheetConfig config;
  /// List of field configurations
  final List<FormFieldConfig> fields;

  /// Submit button text
  final String submitText;

  /// Cancel button text
  final String cancelText;

  /// Whether to show cancel button
  final bool showCancel;

  /// Transform form data to result type
  final T Function(Map<String, dynamic> data) onSubmit;

  /// Form-level validator
  final String? Function(Map<String, dynamic>)? formValidator;

  const FormBottomSheet({
    this.title,
    this.icon,
    required this.fields,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.showCancel = true,
    required this.onSubmit,
    this.formValidator,
    this.config = const BottomSheetConfig(),
  });

  Widget build(BuildContext context) {
    return _FormBottomSheetContent<T>(
      sheet: this,
      config: config,
    );
  }

  /// Show the form bottom sheet
  Future<T?> show(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: config.isDismissible,
      enableDrag: config.enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => build(context),
    );
  }
}

/// Stateful content for form bottom sheet
class _FormBottomSheetContent<T> extends StatefulWidget {
  final FormBottomSheet<T> sheet;
  final BottomSheetConfig config;

  const _FormBottomSheetContent({
    required this.sheet,
    required this.config,
  });

  @override
  State<_FormBottomSheetContent<T>> createState() => _FormBottomSheetContentState<T>();
}

class _FormBottomSheetContentState<T> extends State<_FormBottomSheetContent<T>> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, bool> _obscureText;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _obscureText = {};
    for (final field in widget.sheet.fields) {
      _controllers[field.name] = TextEditingController(text: field.initialValue);
      if (field.type == FormFieldType.password) {
        _obscureText[field.name] = true;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _getFormData() {
    final data = <String, dynamic>{};
    for (final field in widget.sheet.fields) {
      data[field.name] = _controllers[field.name]?.text ?? '';
    }
    return data;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = _getFormData();
      
      // Run form-level validation
      if (widget.sheet.formValidator != null) {
        final error = widget.sheet.formValidator!(data);
        if (error != null) {
          setState(() => _formError = error);
          return;
        }
      }
      
      setState(() => _formError = null);
      final result = widget.sheet.onSubmit(data);
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final backgroundColor = widget.config.backgroundColor ?? 
        (isDark ? AppColors.dark.card : AppColors.light.card);
    final borderRadius = widget.config.borderRadius ?? 
        const BorderRadius.vertical(top: Radius.circular(20));
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;

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
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: widget.config.padding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      if (widget.sheet.title != null || widget.sheet.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              if (widget.sheet.icon != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: context.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(kRadius),
                                  ),
                                  child: Icon(
                                    widget.sheet.icon,
                                    color: context.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (widget.sheet.title != null)
                                Expanded(
                                  child: Text(
                                    widget.sheet.title!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      // Form error
                      if (_formError != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(kRadius),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.circleAlert, color: AppColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formError!,
                                  style: TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Fields
                      ...widget.sheet.fields.map((field) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildField(context, field),
                      )),
                      const SizedBox(height: 4),
                      // Actions
                      _buildActions(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, FormFieldConfig field) {
    final isDark = context.isDarkMode;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.1);

    final isPassword = field.type == FormFieldType.password;
    final obscure = _obscureText[field.name] ?? false;

    return TextFormField(
      controller: _controllers[field.name],
      keyboardType: field.keyboardType,
      obscureText: isPassword && obscure,
      maxLines: isPassword ? 1 : field.maxLines,
      maxLength: field.maxLength,
      inputFormatters: field.inputFormatters,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.hint,
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
        prefixIcon: field.prefixIcon != null 
            ? Icon(field.prefixIcon, color: textSecondary, size: 20)
            : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText[field.name] = !obscure;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: context.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius),
          borderSide: BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: isDark 
            ? Colors.white.withValues(alpha: 0.05) 
            : Colors.black.withValues(alpha: 0.02),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (field.required && (value == null || value.isEmpty)) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    final isDark = context.isDarkMode;

    return Row(
      children: [
        if (widget.sheet.showCancel) ...[
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
                widget.sheet.cancelText,
                style: TextStyle(
                  color: isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: widget.sheet.showCancel ? 1 : 1,
          child: ElevatedButton(
            onPressed: _submit,
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
              widget.sheet.submitText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
