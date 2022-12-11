import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:auth_repository/auth_repository.dart' as auth_repository;
import '../models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final String authReposiotryUrl;
  final auth_repository.AuthRepository _authRepository;

  AuthBloc({required this.authReposiotryUrl})
      : _authRepository =
            auth_repository.AuthRepository(url: authReposiotryUrl),
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
    emit(
        const AuthState.unauthenticated(error: auth_repository.AuthError.none));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) => {
        'status': state.status.name,
        'token': state.token,
        'error': state.error.name,
      };

  Future<void> signUpByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signUpByUserName(
        userName: userName, password: password);
    if (auth.error == auth_repository.AuthError.none) {
      add(_AuthOk(auth.token));
    } else {
      add(_AuthError(auth.error));
    }
  }

  Future<void> signInByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signInByUserName(
        userName: userName, password: password);
    if (auth.error == auth_repository.AuthError.none) {
      add(_AuthOk(auth.token));
    } else {
      add(_AuthError(auth.error));
    }
  }
}
