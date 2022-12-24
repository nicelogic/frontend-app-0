import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  static const _kLogSource = 'AppBlocObserver';

  @override
  void onCreate(BlocBase bloc) {
    log(name: _kLogSource, '${bloc.runtimeType} create');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(name: _kLogSource, 'state ${bloc.runtimeType} $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(name: _kLogSource, 'event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(name: _kLogSource, '$transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(name: _kLogSource, '$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log(name: _kLogSource, '${bloc.runtimeType} close');
    super.onClose(bloc);
  }
}
