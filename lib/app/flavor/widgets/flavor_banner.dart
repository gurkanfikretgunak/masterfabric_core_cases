import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../flavor_config.dart';

/// Global key for accessing navigator context
final GlobalKey<NavigatorState> flavorBannerNavigatorKey =
    GlobalKey<NavigatorState>();

/// Banner widget to display current flavor in debug mode
class FlavorBanner extends StatefulWidget {
  final Widget child;
  final bool show;

  const FlavorBanner({super.key, required this.child, this.show = true});

  @override
  State<FlavorBanner> createState() => _FlavorBannerState();
}

class _FlavorBannerState extends State<FlavorBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  int _expandState = 0; // 0: extra small, 1: small, 2: expanded
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expandState = (_expandState + 1) % 3;
      if (_expandState == 0) {
        _controller.animateTo(0.0);
      } else if (_expandState == 1) {
        _controller.animateTo(0.5);
      } else {
        _controller.animateTo(1.0);
      }
    });
  }

  void _showDetailedConfig() {
    // Hide banner when opening bottom sheet
    setState(() {
      _isBottomSheetOpen = true;
      if (_expandState != 0) {
        _controller.animateTo(0.0);
        _expandState = 0;
      }
    });

    // Use the global navigator key to get the correct context
    final navigatorContext = flavorBannerNavigatorKey.currentContext;
    if (navigatorContext != null) {
      _showDetailedConfigSheet(navigatorContext).then((_) {
        // Show banner again when bottom sheet is closed
        if (mounted) {
          setState(() {
            _isBottomSheetOpen = false;
          });
        }
      });
    }
  }

  String _getShortEnvironmentName(String name) {
    switch (name.toLowerCase()) {
      case 'development':
        return 'DEV';
      case 'staging':
        return 'STG';
      case 'production':
        return 'PROD';
      default:
        return name.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show || !FlavorConfig.isInitialized) {
      return widget.child;
    }

    final config = FlavorConfig.instance;

    // Don't show banner in production
    if (config.isProduction) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          if (!_isBottomSheetOpen)
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: GestureDetector(
                onTap: _toggleExpand,
                child: AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) {
                    // Calculate dimensions based on animation value
                    final double baseWidth = 6; // Extra small width
                    final double smallWidth = 32; // Small width
                    final double expandedWidth = 140; // Expanded width

                    double currentWidth;
                    if (_expandAnimation.value <= 0.5) {
                      // Transition from extra small to small
                      currentWidth =
                          baseWidth +
                          ((smallWidth - baseWidth) *
                              _expandAnimation.value *
                              2);
                    } else {
                      // Transition from small to expanded
                      currentWidth =
                          smallWidth +
                          ((expandedWidth - smallWidth) *
                              (_expandAnimation.value - 0.5) *
                              2);
                    }

                    return ClipRect(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: _expandState == 2 ? 100 : 60,
                          maxHeight: _expandState == 2 ? 100 : 60,
                        ),
                        width: currentWidth,
                        decoration: BoxDecoration(
                          color: _getBannerColor(config.flavor),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              _expandState == 0 ? 8 : 16,
                            ),
                            bottomLeft: Radius.circular(
                              _expandState == 0 ? 8 : 16,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: _expandState == 0 ? 4 : 6,
                              offset: const Offset(-2, 0),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Extra small state - just a colored line
                            if (_expandState == 0)
                              Center(
                                child: Container(
                                  width: 3,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            // Small state - vertical text
                            if (_expandState == 1)
                              Center(
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    _getShortEnvironmentName(config.name),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            // Expanded content
                            if (_expandState == 2)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getShortEnvironmentName(config.name),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Debug: ${config.debugMode ? "ON" : "OFF"}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 8,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 20,
                                              minHeight: 20,
                                            ),
                                            iconSize: 16,
                                            icon: const Icon(
                                              Icons.info_outline,
                                              color: Colors.white,
                                            ),
                                            onPressed: _showDetailedConfig,
                                          ),
                                          const SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 20,
                                              minHeight: 20,
                                            ),
                                            iconSize: 16,
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: _toggleExpand,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showDetailedConfigSheet(BuildContext context) async {
    final config = FlavorConfig.instance;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBannerColor(config.flavor),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getFlavorIcon(config.flavor),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: config.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' Configuration',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          LucideIcons.x,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.info,
                        color: Colors.white60,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'View and manage your ${config.name} environment settings',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildConfigSection('Basic Information', [
                    _buildConfigItem('Environment', config.name.toUpperCase()),
                    _buildConfigItem('App Name', config.appName),
                    _buildConfigItem('API Base URL', config.apiBaseUrl),
                    _buildConfigItem(
                      'Debug Mode',
                      config.debugMode ? 'Enabled' : 'Disabled',
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildConfigSection(
                    'Additional Configuration',
                    _buildAdditionalConfigItems(config.additionalConfig),
                  ),
                  const SizedBox(height: 16),
                  _buildConfigSection(
                    'All Configuration Keys',
                    _buildAllConfigItems(config),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildConfigItem(String key, String value) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      title: Text(
        key,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.copy, size: 16),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  List<Widget> _buildAdditionalConfigItems(Map<String, dynamic> config) {
    if (config.isEmpty) {
      return [
        const ListTile(dense: true, title: Text('No additional configuration')),
      ];
    }

    return config.entries.map((entry) {
      return _buildConfigItem(entry.key, entry.value.toString());
    }).toList();
  }

  List<Widget> _buildAllConfigItems(FlavorConfig config) {
    final items = <Widget>[];

    // Get all config keys dynamically
    final configMap = {
      'name': config.name,
      'appName': config.appName,
      'apiBaseUrl': config.apiBaseUrl,
      'debugMode': config.debugMode.toString(),
      'flavor': config.flavor.toString(),
      'isProduction': config.isProduction.toString(),
      'isStaging': config.isStaging.toString(),
      'isDevelopment': config.isDevelopment.toString(),
    };

    for (final entry in configMap.entries) {
      items.add(_buildConfigItem(entry.key, entry.value));
    }

    return items;
  }

  Color _getBannerColor(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return Colors.green;
      case Flavor.staging:
        return Colors.orange;
      case Flavor.production:
        return Colors.red;
    }
  }

  IconData _getFlavorIcon(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return LucideIcons.code;
      case Flavor.staging:
        return LucideIcons.testTube;
      case Flavor.production:
        return LucideIcons.rocket;
    }
  }
}
