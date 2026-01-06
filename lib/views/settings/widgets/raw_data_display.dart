import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core_cases/app/theme/theme.dart';
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
    final isDark = context.isDarkMode;

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
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          leading: ThemedWidgets.iconBox(
            context: context,
            icon: LucideIcons.code,
            color: AppColors.warning,
            backgroundColor: AppColors.warningLight,
            size: 40,
            iconSize: 18,
          ),
          title: Text(
            'Raw JSON Data (Stored Data)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          subtitle: Text(
            'Raw data stored in HydratedBloc storage',
            style: TextStyle(
              color: context.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          iconColor: context.iconSecondaryColor,
          collapsedIconColor: context.iconSecondaryColor,
          children: [
            Container(
              width: double.infinity,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Serialized State (JSON Format)',
                          style: TextStyle(
                            color: context.codeTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            LucideIcons.copy,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: isDark ? AppColors.dark.card : AppColors.success,
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.check, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    const Flexible(child: Text('JSON copied!')),
                                  ],
                                ),
                              ),
                            );
                          },
                          tooltip: 'Copy',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  // Code content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      _formatJson(jsonData),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: context.codeTextColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // Info bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.codeHeaderColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(kRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              LucideIcons.info,
                              color: AppColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'This data is stored unencrypted on the device by HydratedBloc.',
                                style: TextStyle(
                                  color: context.textSecondaryColor,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _DataChip(
                              icon: LucideIcons.fileJson,
                              label: 'Keys: ${jsonData.keys.length}',
                              color: AppColors.purple,
                            ),
                            const SizedBox(width: 8),
                            _DataChip(
                              icon: LucideIcons.hardDrive,
                              label: '${_calculateStorageSize(jsonData)} bytes',
                              color: AppColors.cyan,
                            ),
                            const SizedBox(width: 8),
                            _DataChip(
                              icon: LucideIcons.clock,
                              label: 'Auto-saved',
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DataChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.25 : 0.15),
        borderRadius: BorderRadius.circular(kRadius - 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
