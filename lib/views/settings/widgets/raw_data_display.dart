import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/views/settings/cubit/settings_state.dart';

/// Raw JSON data display section
class RawDataDisplaySection extends StatelessWidget {
  final SettingsState state;

  const RawDataDisplaySection({super.key, required this.state});

  String _formatJson(Map<String, dynamic> json) {
    final buffer = StringBuffer()..writeln('{');
    final entries = json.entries.toList();

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('  "${entry.key}": ');

      if (entry.value is String) {
        buffer.write('"${entry.value}"');
      } else {
        buffer.write(entry.value);
      }

      buffer.writeln(i < entries.length - 1 ? ',' : '');
    }

    buffer.write('}');
    return buffer.toString();
  }

  int _calculateStorageSize(Map<String, dynamic> json) => json.toString().length;

  @override
  Widget build(BuildContext context) {
    final jsonData = state.toJson();

    return Card(
      color: Colors.orange.shade50,
      child: ExpansionTile(
        leading: Icon(LucideIcons.code, color: Colors.orange.shade700),
        title: Text(
          'Raw JSON Data (Stored Data)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
          ),
        ),
        subtitle: Text(
          'Raw data stored in HydratedBloc storage',
          style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.braces,
                        color: Colors.green.shade400, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Serialized State (JSON Format)',
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(LucideIcons.copy,
                          color: Colors.blue.shade300, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.check,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                const Flexible(child: Text('JSON copied!')),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: SelectableText(
                    _formatJson(jsonData),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.green.shade300,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(LucideIcons.info, color: Colors.blue.shade400, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This data is stored unencrypted on the device by HydratedBloc.',
                        style: TextStyle(
                          color: Colors.blue.shade300,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DataChip(
                      icon: LucideIcons.fileJson,
                      label: 'Total Keys: ${jsonData.keys.length}',
                      color: Colors.purple,
                    ),
                    _DataChip(
                      icon: LucideIcons.hardDrive,
                      label: 'Storage: ${_calculateStorageSize(jsonData)} bytes',
                      color: Colors.cyan,
                    ),
                    const _DataChip(
                      icon: LucideIcons.clock,
                      label: 'Auto-saved',
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final MaterialColor color;

  const _DataChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 14, color: color.shade100),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color.shade100,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

