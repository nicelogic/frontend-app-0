import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  static const kLogSource = 'AppBlocObserver';

  @override
  void onCreate(BlocBase bloc) {
    log(name: kLogSource, '${bloc.runtimeType} create');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(name: kLogSource, '${bloc.runtimeType} $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(name: kLogSource, '$event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(name: kLogSource, '$transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(name: kLogSource, '$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log(name: kLogSource, '${bloc.runtimeType} close');
    super.onClose(bloc);
  }
}
