import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:auth_repository/auth_repository.dart';
import '../models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.g.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final String authReposiotryUrl;
  final AuthRepository _authRepository;
  static const kLogSource = 'AuthBloc';

  AuthBloc({required this.authReposiotryUrl})
      : _authRepository = AuthRepository(url: authReposiotryUrl),
        super(const AuthState.authInitial()) {
    on<_AuthOk>(_onAuthOk);
    on<_AuthError>(_onAuthError);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  _onAuthOk(_AuthOk event, Emitter<AuthState> emit) async {
    emit(AuthState.authenticated(token: event.token));
  }

  _onAuthError(_AuthError event, Emitter<AuthState> emit) async {
    emit(AuthState.unauthenticated(error: event.error));
  }

  _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.unauthenticated(error: AuthError.none));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    log(name: kLogSource, 'fromJson($json)');
    return _$AuthStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    log(name: kLogSource, 'toJson($state)');
    return _$AuthStateToJson(state);
  } 

  Future<void> signUpByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signUpByUserName(
        userName: userName, password: password);
    if (auth.error == AuthError.none) {
      add(_AuthOk(auth.token));
    } else {
      add(_AuthError(auth.error));
    }
  }

  Future<void> signInByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signInByUserName(
        userName: userName, password: password);
    if (auth.error == AuthError.none) {
      add(_AuthOk(auth.token));
    } else {
      add(_AuthError(auth.error));
    }
  }
}
