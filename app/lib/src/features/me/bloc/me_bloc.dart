import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:app/src/features/auth/auth.dart' as auth;
// import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

part 'me_event.dart';
part 'me_state.dart';
part 'me_bloc.g.dart';

const _kLogSource = 'MeBloc';

class MeBloc extends HydratedBloc<MeEvent, MeState> {
  final user_repository.UserRepository userRepository;
  final auth.AuthBloc authBloc;

  MeBloc({required this.userRepository, required this.authBloc})
      : super(const MeState.meInitial()) {
    on<FetchMe>(
      _onFetchMe,
      // transformer: (events, mapper) => events
      //     .debounceTime(const Duration(seconds: 60))
      //     .asyncExpand(mapper)
    );
    on<UpdateAvatarUrl>(_onUpdateAvatarUrl);
    on<UpdateName>(_onUpdateName);
  }

  _onFetchMe(event, emit) async {
    final me = await userRepository.me();
    me.error != user_repository.UserError.none
        ? emit(state.copyWith(me: state.me.copyWith(error: me.error)))
        : emit(MeState(me: Me.fromUser(me)));
  }

  _onUpdateAvatarUrl(UpdateAvatarUrl event, emit) async {
    final user = await userRepository.updateUser(
        properties: {user_repository.kAvatarUrl: event.anonymousAccessUrl});
    log(
        name: _kLogSource,
        'update user(${user.id}), avatar url(${user.avatarUrl})');
    user.error != user_repository.UserError.none
        ? emit(state.copyWith(me: state.me.copyWith(error: user.error)))
        : emit(
            state.copyWith(me: state.me.copyWith(avatarUrl: user.avatarUrl)));
  }

  _onUpdateName(UpdateName event, emit) async {
    final user = await userRepository
        .updateUser(properties: {user_repository.kName: event.name});
    log(name: _kLogSource, 'update user(${user.id}), name(${user.name})');
    user.error != user_repository.UserError.none
        ? emit(state.copyWith(me: state.me.copyWith(error: user.error)))
        : emit(state.copyWith(me: state.me.copyWith(name: user.name)));
  }

  @override
  MeState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    final meState = _$MeStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: _kLogSource,
        'current userId($userId), cached userId(${meState.me.id})');
    if (meState.me.id != userId) {
      return const MeState.meInitial();
    } else {
      return meState;
    }
  }

  @override
  Map<String, dynamic>? toJson(MeState state) {
    log(name: _kLogSource, 'toJson($state)');
    return _$MeStateToJson(state);
  }
}
