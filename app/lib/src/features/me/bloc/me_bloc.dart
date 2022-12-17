import 'dart:async';
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

  MeBloc(this.userRepository, this.authBloc) : super(MeState.meInitial()) {
    on<_MeFetched>(_onMeFetched);
    on<_Logout>(_onLogout);

    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          add(_Logout());
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
    emit(event.me);
  }

  _onLogout(_Logout event, emit) async {
    emit(MeState.meInitial());
  }

  @override
  MeState? fromJson(Map<String, dynamic> json) {
    log(name: kLogSource, 'fromJson($json)');
    return _$MeStateFromJson(json);
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
