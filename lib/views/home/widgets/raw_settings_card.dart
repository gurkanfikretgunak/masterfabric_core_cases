import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

  Widget _buildDataChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, size: 14, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the SettingsCubit instance from GetIt
    final settingsCubit = GetIt.instance<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, state) {
        return Card(
          elevation: 4,
          color: Colors.orange.shade50,
          child: ExpansionTile(
            leading: Icon(LucideIcons.code, color: Colors.orange.shade700),
            title: Text(
              'Raw Settings Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
            subtitle: Text(
              'Canlı HydratedCubit state verisi',
              style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
            ),
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: double.infinity,
                    height: constraints.maxWidth * 0.5,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LucideIcons.braces,
                              color: Colors.green.shade400,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Serialized State (JSON)',
                                style: TextStyle(
                                  color: Colors.green.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                LucideIcons.copy,
                                color: Colors.blue.shade300,
                                size: 18,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          LucideIcons.check,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Flexible(
                                          child: Text('JSON copied!'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              tooltip: 'Copy',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade700),
                            ),
                            child: SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SelectableText(
                                  _formatJson(state.toJson()),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Colors.green.shade300,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.info,
                              color: Colors.blue.shade400,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'This data is automatically saved by HydratedCubit.',
                                style: TextStyle(
                                  color: Colors.blue.shade300,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildDataChip(
                                LucideIcons.fileJson,
                                'Keys: ${state.toJson().keys.length}',
                                Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              _buildDataChip(
                                LucideIcons.hardDrive,
                                '${_calculateStorageSize(state.toJson())} bytes',
                                Colors.cyan,
                              ),
                              const SizedBox(width: 8),
                              _buildDataChip(
                                LucideIcons.clock,
                                'Auto-saved',
                                Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
