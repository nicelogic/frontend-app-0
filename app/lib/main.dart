import 'dart:developer';

import 'package:app/src/configs/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/src/bloc_observer.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Config.instance().loadConfigs();

  final hydratedBlocStorageDir = kIsWeb
      ? HydratedStorage.webStorageDirectory
      : await getApplicationDocumentsDirectory();
  log('hydratedBlocStorageDir(${hydratedBlocStorageDir.path})');
  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: hydratedBlocStorageDir);
  Bloc.observer = AppBlocObserver();
  Bloc.transformer = sequential<dynamic>();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
