import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:app/src/features/auth/auth.dart' as auth;

import '../models/models.dart';

part 'me_event.dart';
part 'me_state.dart';
part 'me_bloc.g.dart';

const kLogSource = 'MeBloc';

class MeBloc extends HydratedBloc<MeEvent, MeState> {
  final user_repository.UserRepository userRepository;
  final auth.AuthBloc authBloc;
  late final StreamSubscription authBlocSubscription;

  MeBloc(this.userRepository, this.authBloc)
      : super(const MeState.meInitial()) {
    on<_MeFetched>(_onMeFetched);
    on<_UnAuthenticated>(_onUnAuthenticated);

    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          log(
              name: kLogSource,
              'auth unauthenticated, update access token empty, and add logout event');
          userRepository.updateToken('');
          add(_UnAuthenticated());
          break;
        case auth.AuthenticationStatus.authenticated:
          userRepository.updateToken(authState.auth.accessToken);
          log(
              name: kLogSource,
              'auth authenticated data change, new access toke(${authState.auth.accessToken})');
          break;
        default:
      }
    });
  }
  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

  _onMeFetched(_MeFetched event, emit) async {
    emit(MeState(me: event.me));
  }

  _onUnAuthenticated(_UnAuthenticated event, emit) async {
    emit(const MeState.meInitial());
  }

  @override
  MeState? fromJson(Map<String, dynamic> json) {
    log(name: kLogSource, 'fromJson($json)');
    final meState = _$MeStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: kLogSource,
        'current userId($userId), cached userId(${meState.me.id})');
    if (meState.me.id != userId) {
      return const MeState.meInitial();
    } else {
      return meState;
    }
  }

  @override
  Map<String, dynamic>? toJson(MeState state) {
    log(name: kLogSource, 'toJson($state)');
    return _$MeStateToJson(state);
  }

  me() async {
    final me = await userRepository.me();
    add(_MeFetched(Me.fromUser(me)));
  }
}
