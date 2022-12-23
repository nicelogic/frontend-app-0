import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:app/src/features/auth/auth.dart' as auth;
import '../models/models.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';
part 'my_profile_bloc.g.dart';

const kLogSource = 'my_profile_bloc';

class MyProfileBloc extends HydratedBloc<MyProfileEvent, MyProfileState> {
  final user_repository.UserRepository userRepository;
  final auth.AuthBloc authBloc;
  late final StreamSubscription authBlocSubscription;

  MyProfileBloc(this.userRepository, this.authBloc)
      : super(const MyProfileState.myProfileInitial()) {
    on<_UnAuthenticated>(_onUnAuthenticated);
    on<FetchMyProfile>(_onFetchMyProfile);
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

  _onUnAuthenticated(_UnAuthenticated event, emit) async {
    emit(const MyProfileState.myProfileInitial());
  }

  _onFetchMyProfile(event, emit) async {
    final me = await userRepository.me();
    emit(MyProfileState(myProfile: MyProfile.fromUser(me)));
  }

  @override
  MyProfileState? fromJson(Map<String, dynamic> json) {
    log(name: kLogSource, 'fromJson($json)');
    final myProfileState = _$MyProfileStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: kLogSource,
        'current userId($userId), cached userId(${myProfileState.myProfile.id})');
    if (myProfileState.myProfile.id != userId) {
      return const MyProfileState.myProfileInitial();
    } else {
      return myProfileState;
    }
  }

  @override
  Map<String, dynamic>? toJson(MyProfileState state) {
    log(name: kLogSource, 'toJson($state)');
    return _$MyProfileStateToJson(state);
  }
}
