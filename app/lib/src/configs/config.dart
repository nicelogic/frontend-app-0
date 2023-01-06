import 'dart:developer';

import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' as services;

class Config {
  Config._();
  static final _instance = Config._();
  factory Config.instance() => _instance;

  late YamlMap _configMap;
  late YamlMap _uiConfigMap;
  static const _kLogSource = 'config';

  loadConfigs() async {
    const configYamlPath = 'assets/configs/config.yml';
    final configs = await services.rootBundle.loadString(configYamlPath);
    _configMap = loadYaml(configs);
    log(name: _kLogSource, 'load config success');

    _uiConfigMap =
        loadYaml(await services.rootBundle.loadString('assets/configs/ui.yml'));
    log(name: _kLogSource, 'load ui config success');
  }

  dynamic _serviceSection(final String name) => _configMap['services'][name];
  String get authServiceUrl {
    final url = _serviceSection('auth') as String;
    log(name: _kLogSource, 'authServiceUrl($url)');
    return url;
  }

  String get userServiceUrl {
    final url = _serviceSection('user') as String;
    log(name: _kLogSource, 'userServiceUrl($url)');
    return url;
  }

  String get contactsServiceUrl {
    final url = _serviceSection('contacts') as String;
    log(name: _kLogSource, 'contactsServiceUrl($url)');
    return url;
  }

  String get messageServiceUrl {
    final url = _serviceSection('message') as String;
    log(name: _kLogSource, 'messageServiceUrl($url)');
    return url;
  }

  dynamic _assetsSection(final String name) => _configMap['assets'][name];
  String get logoPath {
    final logoPath = _assetsSection('logo') as String;
    log(name: _kLogSource, 'logoPath($logoPath)');
    return logoPath;
  }

  int get tokenRefreshMinutes {
    final minutes = _configMap['token_refresh_minutes'] as int;
    log(name: _kLogSource, 'token_refresh_minutes($minutes)');
    return minutes;
  }

  int get failConditionTokenRefreshSeconds{
    final seconds = _configMap['fail_condition_token_refresh_seconds'] as int;
    log(name: _kLogSource, 'fail_condition_token_refresh_seconds($seconds)');
    return seconds;
  }

  double get profilePictureMaxHeight {
    return _uiConfigMap['profile_picture_max_height'] as double;
  }

  double get profilePictureMaxWidth {
    return _uiConfigMap['profile_picture_max_width'] as double;
  }

  int get contactsPageSize {
    return _uiConfigMap['contactsPageSize'] as int;
  }

  int get contactsInvisibleItemsThreshold {
    return _uiConfigMap['contactsInvisibleItemsThreshold'] as int;
  }
}
