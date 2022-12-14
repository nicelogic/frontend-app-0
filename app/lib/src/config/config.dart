import 'dart:developer';

import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' as services;

class Config {
  Config._();
  static final _instance = Config._();
  factory Config.instance() => _instance;

  late YamlMap _configMap;
  static const kLogSource = 'config';

  loadConfigs() async {
    const configYamlPath = 'assets/configs/config.yml';
    final configs = await services.rootBundle.loadString(configYamlPath);
    _configMap = loadYaml(configs);
    log(name: kLogSource, 'load config success');
  }

  dynamic _serviceSection(final String name) => _configMap['services'][name];
  String get authServiceUrl {
    final authUrl = _serviceSection('auth') as String;
    log(name: kLogSource, 'authServiceUrl($authUrl)');
    return authUrl;
  }

  dynamic _assetsSection(final String name) => _configMap['assets'][name];
  String get logoPath {
    final logoPath = _assetsSection('logo') as String;
    log(name: kLogSource, 'logoPath($logoPath)');
    return logoPath;
  }

  int get accessTokenRefreshMinutes =>
      _configMap['access_token_refresh_minutes'] as int;
}
