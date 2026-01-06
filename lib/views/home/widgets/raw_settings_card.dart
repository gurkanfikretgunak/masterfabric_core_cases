import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_cubit.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';
import 'dart:convert';

/// Standard border radius
const double _kRadius = 7.0;

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
        borderRadius: BorderRadius.circular(_kRadius),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(_kRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
                borderRadius: BorderRadius.circular(_kRadius),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_kRadius),
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(_kRadius),
                ),
                child: const Icon(
                  LucideIcons.code,
                  color: Color(0xFF9C27B0),
                  size: 18,
                ),
              ),
              title: const Text(
                'Raw Settings Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'Live HydratedCubit state',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(_kRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(_kRadius),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.braces,
                              color: Colors.green.shade400,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'settings_state.json',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
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
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(_kRadius),
                                    ),
                                    backgroundColor: const Color(0xFF323232),
                                    content: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.check, color: Color(0xFF4CAF50), size: 18),
                                        SizedBox(width: 10),
                                        Text('JSON copied to clipboard'),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(_kRadius),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  LucideIcons.copy,
                                  color: Colors.grey.shade500,
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
                                color: Colors.green.shade400,
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
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(_kRadius),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatBadge(
                                LucideIcons.key,
                                '${state.toJson().keys.length} keys',
                                const Color(0xFF9C27B0),
                              ),
                              const SizedBox(width: 8),
                              _buildStatBadge(
                                LucideIcons.hardDrive,
                                '${_calculateStorageSize(state.toJson())} bytes',
                                const Color(0xFF00BCD4),
                              ),
                              const SizedBox(width: 8),
                              _buildStatBadge(
                                LucideIcons.zap,
                                'Auto-sync',
                                const Color(0xFF4CAF50),
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
