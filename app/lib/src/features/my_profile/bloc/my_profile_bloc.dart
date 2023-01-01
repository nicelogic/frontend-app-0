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

const _kLogSource = 'my_profile_bloc';

class MyProfileBloc extends HydratedBloc<MyProfileEvent, MyProfileState> {
  final user_repository.UserRepository userRepository;
  final auth.AuthBloc authBloc;

  MyProfileBloc({required this.authBloc, required this.userRepository})
      : super(const MyProfileState.myProfileInitial()) {
    on<FetchMyProfile>(_onFetchMyProfile);
    on<UpdateSignature>(_onUpdateSignature);
  }

  _onFetchMyProfile(event, emit) async {
    final me = await userRepository.me();
    emit(MyProfileState(myProfile: MyProfile.fromUser(me)));
  }

  _onUpdateSignature(UpdateSignature event, emit) async {
    final user = await userRepository
        .updateUser(properties: {user_repository.kSignature: event.signature});
    log(
        name: _kLogSource,
        'update user(${user.id}), signature(${user.signature})');
    user.error != user_repository.UserError.none
        ? emit(state.copyWith(
            myProfile: state.myProfile.copyWith(error: user.error)))
        : emit(state.copyWith(
            myProfile: state.myProfile.copyWith(signature: user.signature)));
  }

  @override
  MyProfileState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    final myProfileState = _$MyProfileStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: _kLogSource,
        'current userId($userId), cached userId(${myProfileState.myProfile.id})');
    if (myProfileState.myProfile.id != userId) {
      return const MyProfileState.myProfileInitial();
    } else {
      return myProfileState;
    }
  }

  @override
  Map<String, dynamic>? toJson(MyProfileState state) {
    log(name: _kLogSource, 'toJson($state)');
    return _$MyProfileStateToJson(state);
  }
}
