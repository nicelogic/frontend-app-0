import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

part 'me_event.dart';
part 'me_state.dart';
part 'me_bloc.g.dart';

const kLogSource = 'MeBloc';

class MeBloc extends HydratedBloc<MeEvent, MeState> {
  final user_repository.UserRepository userRepository;
  final auth.AuthBloc authBloc;

  MeBloc({required this.userRepository, required this.authBloc})
      : super(const MeState.meInitial()) {
    on<FetchMe>(_onFetchMe,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(seconds: 60))
            .asyncExpand(mapper));
  }

  _onFetchMe(event, emit) async {
    final me = await userRepository.me();
    emit(MeState(me: Me.fromUser(me)));
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
}
