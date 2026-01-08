import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/_widgets/widgets.dart';
import 'package:masterfabric_core_cases/views/_widgets/bottom_sheet/bottom_sheet.dart';
import 'package:masterfabric_core_cases/views/bottom_sheet_test/cubit/bottom_sheet_test_cubit.dart';
import 'package:masterfabric_core_cases/views/bottom_sheet_test/cubit/bottom_sheet_test_state.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Test view for demonstrating all bottom sheet variants
class BottomSheetTestView extends MasterViewCubit<BottomSheetTestCubit, BottomSheetTestState> {
  BottomSheetTestView({super.key, required super.goRoute})
      : super(
          currentView: MasterViewCubitTypes.content,
          arguments: const {'title': 'Bottom Sheet Test'},
        );

  @override
  Future<void> initialContent(BottomSheetTestCubit viewModel, BuildContext context) async {
    debugPrint('BottomSheet Test View Initialized');
    await viewModel.initialize();
  }

  @override
  Widget viewContent(
    BuildContext context,
    BottomSheetTestCubit viewModel,
    BottomSheetTestState state,
  ) {
    final settingsCubit = GetIt.instance<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final appBarBg = isDark ? AppColors.dark.appBar : AppColors.light.appBar;
        final appBarFg = isDark ? AppColors.dark.appBarForeground : AppColors.light.appBarForeground;
        final iconColor = isDark ? AppColors.dark.icon : AppColors.light.icon;
        final scaffoldBg = isDark ? AppColors.dark.scaffold : AppColors.light.scaffold;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarBg,
            foregroundColor: appBarFg,
            leading: IconButton(
              icon: Icon(LucideIcons.arrowLeft, color: iconColor),
              onPressed: () => goRoute('/home'),
              tooltip: 'Back to Home',
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.layoutList, color: appBarFg, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Bottom Sheet Test',
                  style: TextStyle(
                    color: appBarFg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                InfoCard(
                  key: ValueKey('info_card_$isDark'),
                  icon: LucideIcons.info,
                  title: 'Abstract Bottom Sheet System',
                  description:
                      'Test all bottom sheet variants: Confirmation, Form, Selection, Action, and Info sheets. '
                      'Each variant extends BaseBottomSheet for consistent behavior.',
                  accentColor: AppColors.purple,
                ),
                const SizedBox(height: 24),

                // Result display
                if (state.lastResult != null || state.lastSelection != null || state.lastFormData != null)
                  _ResultCard(
                    state: state,
                    isDark: isDark,
                    onClear: viewModel.clearResults,
                  ),
                if (state.lastResult != null || state.lastSelection != null || state.lastFormData != null)
                  const SizedBox(height: 24),

                // Confirmation Section
                SectionHeader(
                  key: ValueKey('confirm_header_$isDark'),
                  icon: LucideIcons.circleCheck,
                  title: 'Confirmation Sheets',
                ),
                _ConfirmationSection(viewModel: viewModel, isDark: isDark),
                const SizedBox(height: 24),

                // Form Section
                SectionHeader(
                  key: ValueKey('form_header_$isDark'),
                  icon: LucideIcons.fileInput,
                  title: 'Form Sheets',
                ),
                _FormSection(viewModel: viewModel, isDark: isDark),
                const SizedBox(height: 24),

                // Selection Section
                SectionHeader(
                  key: ValueKey('select_header_$isDark'),
                  icon: LucideIcons.list,
                  title: 'Selection Sheets',
                ),
                _SelectionSection(viewModel: viewModel, isDark: isDark),
                const SizedBox(height: 24),

                // Action Section
                SectionHeader(
                  key: ValueKey('action_header_$isDark'),
                  icon: LucideIcons.zap,
                  title: 'Action Sheets',
                ),
                _ActionSection(viewModel: viewModel, isDark: isDark),
                const SizedBox(height: 24),

                // Info Section
                SectionHeader(
                  key: ValueKey('info_header_$isDark'),
                  icon: LucideIcons.info,
                  title: 'Info Sheets',
                ),
                _InfoSection(viewModel: viewModel, isDark: isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Result display card
class _ResultCard extends StatelessWidget {
  final BottomSheetTestState state;
  final bool isDark;
  final VoidCallback onClear;

  const _ResultCard({
    required this.state,
    required this.isDark,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;
    final textSecondary = isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clipboardCheck, color: context.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Last Result',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(LucideIcons.x, size: 16, color: textSecondary),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.lastResult != null)
            Text(
              'Action: ${state.lastResult}',
              style: TextStyle(color: textSecondary, fontSize: 13),
            ),
          if (state.lastSelection != null)
            Text(
              'Selection: ${state.lastSelection}',
              style: TextStyle(color: textSecondary, fontSize: 13),
            ),
          if (state.lastFormData != null)
            Text(
              'Form: ${state.lastFormData}',
              style: TextStyle(color: textSecondary, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

/// Confirmation section
class _ConfirmationSection extends StatelessWidget {
  final BottomSheetTestCubit viewModel;
  final bool isDark;

  const _ConfirmationSection({required this.viewModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      isDark: isDark,
      children: [
        _TestButton(
          label: 'Normal Confirmation',
          icon: LucideIcons.circleHelp,
          isDark: isDark,
          onTap: () async {
            final result = await context.showConfirmation(
              title: 'Confirm Action',
              message: 'Do you want to proceed with this action?',
            );
            viewModel.setLastResult('Confirmation: ${result ? "Confirmed" : "Cancelled"}');
          },
        ),
        _TestButton(
          label: 'Delete Confirmation',
          icon: LucideIcons.trash2,
          isDark: isDark,
          color: AppColors.error,
          onTap: () async {
            final result = await context.showDeleteConfirmation(
              title: 'Delete Item',
              message: 'Are you sure you want to delete this item? This cannot be undone.',
            );
            viewModel.setLastResult('Delete: ${result ? "Confirmed" : "Cancelled"}');
          },
        ),
        _TestButton(
          label: 'Warning Confirmation',
          icon: LucideIcons.triangleAlert,
          isDark: isDark,
          color: AppColors.warning,
          onTap: () async {
            final result = await context.showWarningConfirmation(
              title: 'Warning',
              message: 'This action may have unexpected consequences. Continue anyway?',
            );
            viewModel.setLastResult('Warning: ${result ? "Confirmed" : "Cancelled"}');
          },
        ),
        _TestButton(
          label: 'Success Confirmation',
          icon: LucideIcons.circleCheck,
          isDark: isDark,
          color: AppColors.success,
          onTap: () async {
            final result = await context.showConfirmation(
              title: 'Success',
              message: 'Your changes have been saved successfully!',
              type: ConfirmationType.success,
              confirmText: 'Great!',
              cancelText: 'View Details',
            );
            viewModel.setLastResult('Success: ${result ? "Great" : "View Details"}');
          },
        ),
      ],
    );
  }
}

/// Form section
class _FormSection extends StatelessWidget {
  final BottomSheetTestCubit viewModel;
  final bool isDark;

  const _FormSection({required this.viewModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      isDark: isDark,
      children: [
        _TestButton(
          label: 'Simple Text Input',
          icon: LucideIcons.type,
          isDark: isDark,
          onTap: () async {
            final result = await context.showTextInput(
              title: 'Enter Name',
              fieldLabel: 'Your Name',
              fieldHint: 'John Doe',
            );
            if (result != null) {
              viewModel.setLastFormData({'name': result});
            }
          },
        ),
        _TestButton(
          label: 'Login Form',
          icon: LucideIcons.logIn,
          isDark: isDark,
          onTap: () async {
            final result = await context.showFormSheet<Map<String, dynamic>>(
              title: 'Login',
              icon: LucideIcons.user,
              fields: [
                FormFieldConfig.email(name: 'email'),
                FormFieldConfig.password(name: 'password', minLength: 6),
              ],
              submitText: 'Login',
              onSubmit: (data) => data,
            );
            if (result != null) {
              viewModel.setLastFormData(result);
            }
          },
        ),
        _TestButton(
          label: 'Contact Form',
          icon: LucideIcons.mail,
          isDark: isDark,
          onTap: () async {
            final result = await context.showFormSheet<Map<String, dynamic>>(
              title: 'Contact Us',
              icon: LucideIcons.messageSquare,
              fields: [
                FormFieldConfig.text(
                  name: 'name',
                  label: 'Name',
                  required: true,
                  prefixIcon: LucideIcons.user,
                ),
                FormFieldConfig.email(name: 'email'),
                FormFieldConfig.phone(name: 'phone'),
                FormFieldConfig.multiline(
                  name: 'message',
                  label: 'Message',
                  hint: 'Enter your message...',
                  required: true,
                  maxLines: 4,
                ),
              ],
              submitText: 'Send',
              onSubmit: (data) => data,
            );
            if (result != null) {
              viewModel.setLastFormData(result);
            }
          },
        ),
      ],
    );
  }
}

/// Selection section
class _SelectionSection extends StatelessWidget {
  final BottomSheetTestCubit viewModel;
  final bool isDark;

  const _SelectionSection({required this.viewModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = [
      SelectionItem(value: 'red', label: 'Red', icon: LucideIcons.palette),
      SelectionItem(value: 'blue', label: 'Blue', icon: LucideIcons.palette),
      SelectionItem(value: 'green', label: 'Green', icon: LucideIcons.palette),
      SelectionItem(value: 'purple', label: 'Purple', icon: LucideIcons.palette),
      SelectionItem(value: 'orange', label: 'Orange', icon: LucideIcons.palette),
    ];

    final countries = [
      const SelectionItem(value: 'us', label: 'United States', subtitle: 'North America'),
      const SelectionItem(value: 'uk', label: 'United Kingdom', subtitle: 'Europe'),
      const SelectionItem(value: 'de', label: 'Germany', subtitle: 'Europe'),
      const SelectionItem(value: 'fr', label: 'France', subtitle: 'Europe'),
      const SelectionItem(value: 'jp', label: 'Japan', subtitle: 'Asia'),
      const SelectionItem(value: 'cn', label: 'China', subtitle: 'Asia'),
      const SelectionItem(value: 'au', label: 'Australia', subtitle: 'Oceania'),
      const SelectionItem(value: 'br', label: 'Brazil', subtitle: 'South America'),
    ];

    return _SectionCard(
      isDark: isDark,
      children: [
        _TestButton(
          label: 'Single Selection',
          icon: LucideIcons.squareCheck,
          isDark: isDark,
          onTap: () async {
            final result = await context.showSingleSelection<String>(
              title: 'Choose Color',
              icon: LucideIcons.palette,
              items: colors,
            );
            if (result != null) {
              viewModel.setLastSelection(result);
            }
          },
        ),
        _TestButton(
          label: 'Multi Selection',
          icon: LucideIcons.listChecks,
          isDark: isDark,
          onTap: () async {
            final result = await context.showMultiSelection<String>(
              title: 'Choose Colors',
              icon: LucideIcons.palette,
              items: colors,
            );
            if (result != null) {
              viewModel.setLastSelection(result.join(', '));
            }
          },
        ),
        _TestButton(
          label: 'Searchable Selection',
          icon: LucideIcons.search,
          isDark: isDark,
          onTap: () async {
            final result = await context.showSingleSelection<String>(
              title: 'Select Country',
              icon: LucideIcons.globe,
              items: countries,
              searchable: true,
              searchHint: 'Search countries...',
            );
            if (result != null) {
              viewModel.setLastSelection(result);
            }
          },
        ),
      ],
    );
  }
}

/// Action section
class _ActionSection extends StatelessWidget {
  final BottomSheetTestCubit viewModel;
  final bool isDark;

  const _ActionSection({required this.viewModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      isDark: isDark,
      children: [
        _TestButton(
          label: 'Custom Actions',
          icon: LucideIcons.ellipsisVertical,
          isDark: isDark,
          onTap: () async {
            final result = await context.showActionSheet(
              title: 'Options',
              icon: LucideIcons.settings,
              actions: [
                const BottomSheetAction(
                  id: 'edit',
                  label: 'Edit',
                  icon: LucideIcons.pencil,
                  subtitle: 'Modify this item',
                ),
                const BottomSheetAction(
                  id: 'duplicate',
                  label: 'Duplicate',
                  icon: LucideIcons.copy,
                  subtitle: 'Create a copy',
                ),
                const BottomSheetAction(
                  id: 'share',
                  label: 'Share',
                  icon: LucideIcons.share2,
                ),
                const BottomSheetAction(
                  id: 'delete',
                  label: 'Delete',
                  icon: LucideIcons.trash2,
                  isDestructive: true,
                ),
              ],
            );
            if (result != null) {
              viewModel.setLastResult('Action: $result');
            }
          },
        ),
        _TestButton(
          label: 'Share Sheet',
          icon: LucideIcons.share2,
          isDark: isDark,
          onTap: () async {
            final result = await context.showShareSheet();
            if (result != null) {
              viewModel.setLastResult('Share: $result');
            }
          },
        ),
        _TestButton(
          label: 'Edit/Delete Sheet',
          icon: LucideIcons.pencil,
          isDark: isDark,
          onTap: () async {
            final result = await context.showEditDeleteSheet(title: 'Item Options');
            if (result != null) {
              viewModel.setLastResult('Edit/Delete: $result');
            }
          },
        ),
        _TestButton(
          label: 'Image Picker',
          icon: LucideIcons.image,
          isDark: isDark,
          onTap: () async {
            final result = await context.showImagePickerSheet();
            if (result != null) {
              viewModel.setLastResult('Image: $result');
            }
          },
        ),
      ],
    );
  }
}

/// Info section
class _InfoSection extends StatelessWidget {
  final BottomSheetTestCubit viewModel;
  final bool isDark;

  const _InfoSection({required this.viewModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      isDark: isDark,
      children: [
        _TestButton(
          label: 'Info Sheet',
          icon: LucideIcons.info,
          isDark: isDark,
          onTap: () async {
            await context.showInfoText(
              title: 'Information',
              text: 'This is an informational message that provides details to the user about something important.',
            );
            viewModel.setLastResult('Info sheet closed');
          },
        ),
        _TestButton(
          label: 'Success Sheet',
          icon: LucideIcons.circleCheck,
          isDark: isDark,
          color: AppColors.success,
          onTap: () async {
            await context.showSuccessSheet(
              title: 'Success!',
              message: 'Your profile has been updated successfully. All changes have been saved.',
            );
            viewModel.setLastResult('Success sheet closed');
          },
        ),
        _TestButton(
          label: 'Error Sheet',
          icon: LucideIcons.circleAlert,
          isDark: isDark,
          color: AppColors.error,
          onTap: () async {
            await context.showErrorSheet(
              title: 'Error',
              message: 'Failed to load data. Please check your internet connection and try again.',
              retryText: 'Retry',
              onRetry: () {
                viewModel.setLastResult('Retry clicked');
              },
            );
            viewModel.setLastResult('Error sheet closed');
          },
        ),
        _TestButton(
          label: 'Warning Sheet',
          icon: LucideIcons.triangleAlert,
          isDark: isDark,
          color: AppColors.warning,
          onTap: () async {
            await context.showWarningSheet(
              title: 'Warning',
              message: 'Your session will expire in 5 minutes. Please save your work.',
            );
            viewModel.setLastResult('Warning sheet closed');
          },
        ),
        _TestButton(
          label: 'Help Sheet',
          icon: LucideIcons.circleHelp,
          isDark: isDark,
          onTap: () async {
            await context.showHelpSheet(
              title: 'Need Help?',
              message: 'Tap on any item to see its details. Swipe left to delete or swipe right to archive.',
            );
            viewModel.setLastResult('Help sheet closed');
          },
        ),
        _TestButton(
          label: 'About Sheet',
          icon: LucideIcons.info,
          isDark: isDark,
          onTap: () async {
            await context.showAboutSheet(
              appName: 'MasterFabric Core',
              version: '1.0.0',
              buildNumber: '42',
              description: 'A comprehensive Flutter demo application showcasing the masterfabric_core package.',
            );
            viewModel.setLastResult('About sheet closed');
          },
        ),
      ],
    );
  }
}

/// Section card container
class _SectionCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SectionCard({
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.dark.card : AppColors.light.card,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.dark.shadow : AppColors.light.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: children,
      ),
    );
  }
}

/// Test button widget
class _TestButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final Color? color;
  final VoidCallback onTap;

  const _TestButton({
    required this.label,
    required this.icon,
    required this.isDark,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;
    final textPrimary = isDark ? AppColors.dark.textPrimary : AppColors.light.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(kRadius),
            border: Border.all(
              color: effectiveColor.withValues(alpha: isDark ? 0.3 : 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: effectiveColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
