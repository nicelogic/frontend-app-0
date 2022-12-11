import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log('${bloc.runtimeType} create');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log('$event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('$transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log('${bloc.runtimeType} close');
    super.onClose(bloc);
  }
}
