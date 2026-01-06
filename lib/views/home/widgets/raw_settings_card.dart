import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'dart:convert';

/// Raw Settings Card - Displays current settings state from HydratedCubit
class RawSettingsCard extends StatelessWidget {
  const RawSettingsCard({super.key});

  String _formatJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  int _calculateStorageSize(Map<String, dynamic> json) {
    return utf8.encode(json.toString()).length;
  }

  Widget _buildStatBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsCubit = GetIt.instance<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, state) {
        final jsonData = _formatJson(state.toJson());
        
        return Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(kRadius),
            boxShadow: [
              BoxShadow(
                color: context.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
              leading: ThemedWidgets.iconBox(
                context: context,
                icon: LucideIcons.code,
                color: AppColors.purple,
                backgroundColor: AppColors.purpleLight,
                size: 40,
                iconSize: 18,
              ),
              title: Text(
                'Raw Settings Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: context.textPrimaryColor,
                ),
              ),
              subtitle: Text(
                'Live HydratedCubit state',
                style: TextStyle(
                  color: context.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: context.codeBackgroundColor,
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.codeHeaderColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(kRadius),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.braces,
                              color: context.codeTextColor,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'settings_state.json',
                                style: TextStyle(
                                  color: context.textTertiaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: jsonData));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.check, color: AppColors.success, size: 18),
                                        const SizedBox(width: 10),
                                        const Text('JSON copied to clipboard'),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(kRadius),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  LucideIcons.copy,
                                  color: context.iconSecondaryColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Code content
                      Container(
                        height: 160,
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectableText(
                              jsonData,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: context.codeTextColor,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Footer stats
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.codeHeaderColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(kRadius),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatBadge(
                                LucideIcons.key,
                                '${state.toJson().keys.length} keys',
                                AppColors.purple,
                              ),
                              const SizedBox(width: 8),
                              _buildStatBadge(
                                LucideIcons.hardDrive,
                                '${_calculateStorageSize(state.toJson())} bytes',
                                AppColors.cyan,
                              ),
                              const SizedBox(width: 8),
                              _buildStatBadge(
                                LucideIcons.zap,
                                'Auto-sync',
                                AppColors.success,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
