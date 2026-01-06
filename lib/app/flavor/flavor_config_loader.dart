import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'flavor_config.dart';

/// Service to load flavor configuration from YAML asset with fallback support
class FlavorConfigLoader {
  static const String _configPath = 'assets/flavor_config.yaml';

  /// Load flavor configuration from YAML asset file with fallback
  static Future<void> loadFromYaml(Flavor flavor) async {
    try {
      await _loadFromYamlInternal(flavor);
    } catch (e) {
      debugPrint('⚠️ Failed to load flavor config from YAML: $e');
      debugPrint('🔄 Falling back to default configuration...');
      await _loadFallbackConfig(flavor);
    }
  }

  /// Internal method to load from YAML
  static Future<void> _loadFromYamlInternal(Flavor flavor) async {
    final yamlString = await rootBundle.loadString(_configPath);
    final dynamic yamlDoc = loadYaml(yamlString);

    if (yamlDoc is! YamlMap) {
      throw Exception(
        'Invalid flavor_config.yaml format - expected map at root',
      );
    }

    final String flavorKey = flavor.name;

    if (!yamlDoc.containsKey(flavorKey)) {
      throw Exception(
        'Configuration for flavor "$flavorKey" not found in flavor_config.yaml',
      );
    }

    final YamlMap flavorConfig = yamlDoc[flavorKey] as YamlMap;

    // Validate required fields
    if (!flavorConfig.containsKey('apiBaseUrl')) {
      throw Exception(
        'Required field "apiBaseUrl" missing for flavor "$flavorKey"',
      );
    }

    // Convert YamlMap to regular Map for additionalConfig
    final Map<String, dynamic> additionalConfig = {};
    if (flavorConfig.containsKey('additionalConfig')) {
      final YamlMap? additional = flavorConfig['additionalConfig'] as YamlMap?;
      if (additional != null) {
        additionalConfig.addAll(_convertYamlMap(additional));
      }
    }

    FlavorConfig.initialize(
      flavor: flavor,
      apiBaseUrl: flavorConfig['apiBaseUrl'] as String,
      appName: flavorConfig['appName'] as String?,
      debugMode: flavorConfig['debugMode'] as bool?,
      additionalConfig: additionalConfig,
    );

    debugPrint('✅ Flavor configuration loaded successfully from YAML');
  }

  /// Load fallback configuration when YAML fails
  static Future<void> _loadFallbackConfig(Flavor flavor) async {
    final Map<String, dynamic> fallbackConfig = _getFallbackConfig(flavor);

    FlavorConfig.initialize(
      flavor: flavor,
      apiBaseUrl: fallbackConfig['apiBaseUrl'] as String,
      appName: fallbackConfig['appName'] as String?,
      debugMode: fallbackConfig['debugMode'] as bool?,
      additionalConfig:
          fallbackConfig['additionalConfig'] as Map<String, dynamic>,
    );

    debugPrint('✅ Fallback configuration loaded for ${flavor.name}');
  }

  /// Get fallback configuration for a flavor
  static Map<String, dynamic> _getFallbackConfig(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return {
          'apiBaseUrl': 'https://api-dev.masterfabric.com',
          'appName': 'MasterFabric [DEV]',
          'debugMode': true,
          'additionalConfig': {
            'apiTimeout': 30000,
            'enableLogging': true,
            'enableAnalytics': false,
            'mockData': true,
            'features': ['debug_menu', 'network_inspector'],
          },
        };
      case Flavor.staging:
        return {
          'apiBaseUrl': 'https://api-staging.masterfabric.com',
          'appName': 'MasterFabric [STAGING]',
          'debugMode': true,
          'additionalConfig': {
            'apiTimeout': 45000,
            'enableLogging': true,
            'enableAnalytics': true,
            'mockData': false,
            'features': ['debug_menu'],
          },
        };
      case Flavor.production:
        return {
          'apiBaseUrl': 'https://api.masterfabric.com',
          'appName': 'MasterFabric',
          'debugMode': false,
          'additionalConfig': {
            'apiTimeout': 30000,
            'enableLogging': false,
            'enableAnalytics': true,
            'mockData': false,
            'features': [],
          },
        };
    }
  }

  /// Convert YamlMap to regular Map recursively
  static Map<String, dynamic> _convertYamlMap(YamlMap yamlMap) {
    final Map<String, dynamic> result = {};

    for (final entry in yamlMap.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is YamlMap) {
        result[key] = _convertYamlMap(value);
      } else if (value is YamlList) {
        result[key] = _convertYamlList(value);
      } else {
        result[key] = value;
      }
    }

    return result;
  }

  /// Convert YamlList to regular List recursively
  static List<dynamic> _convertYamlList(YamlList yamlList) {
    return yamlList.map((item) {
      if (item is YamlMap) {
        return _convertYamlMap(item);
      } else if (item is YamlList) {
        return _convertYamlList(item);
      } else {
        return item;
      }
    }).toList();
  }
}
