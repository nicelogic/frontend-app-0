import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/src/configs/configs.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:auth_repository/auth_repository.dart' as auth_repository;
import '../models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.g.dart';

const _kLogSource = 'AuthBloc';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final auth_repository.AuthRepository authRepository;
  StreamSubscription<_AuthRefreshTokenTimerIsUp>?
      _refreshTokenTimerSubscription;

  AuthBloc({required this.authRepository})
      : super(const AuthState.authInitial()) {
    on<AuthSignInByUserName>(_onSignInByUserName);
    on<AuthSignUpByUserName>(_onSignUpByUserName);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<_AuthOk>(_onAuthOk);
    on<_AuthError>(_onAuthError);
    on<_AuthRefreshTokenTimerIsUp>(_onAuthRefreshTokenTimerIsUp);

    if (state.status == AuthenticationStatus.authenticated) {
      log(
          name: _kLogSource,
          time: DateTime.now(),
          '(${DateTime.now()})authenticated, start to refresh access & refresh token and triger timer to auto refressh');
      add(_AuthRefreshTokenTimerIsUp());
      _refreshTokenTimerSubscription =
          Stream<_AuthRefreshTokenTimerIsUp>.periodic(
              Duration(minutes: Config.instance().accessTokenRefreshMinutes),
              (x) => _AuthRefreshTokenTimerIsUp()).listen((event) {
        add(_AuthRefreshTokenTimerIsUp());
      });
    }
  }

  _onSignUpByUserName(
      AuthSignUpByUserName event, Emitter<AuthState> emit) async {
    final auth = await authRepository.signUpByUserName(
        userName: event.userName, password: event.pwd);
    if (auth.error == auth_repository.AuthError.none) {
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else {
      add(_AuthError(auth.error));
    }
  }

  _onSignInByUserName(
      AuthSignInByUserName event, Emitter<AuthState> emit) async {
    final auth = await authRepository.signInByUserName(
        userName: event.userName, password: event.pwd);
    if (auth.error == auth_repository.AuthError.none) {
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else {
      add(_AuthError(auth.error));
    }
  }

  _onAuthOk(_AuthOk event, Emitter<AuthState> emit) async {
    emit(AuthState.authenticated(
        refreshToken: event.refreshToken, accessToken: event.accessToken));
  }

  _onAuthError(_AuthError event, Emitter<AuthState> emit) async {
    emit(AuthState.unauthenticated(error: event.error));
  }

  _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.unauthenticated(error: auth_repository.AuthError.none));
  }

  _onAuthRefreshTokenTimerIsUp(
      _AuthRefreshTokenTimerIsUp event, Emitter<AuthState> emit) async {
    final refreshToken = state.auth.refreshToken;
    log(
        name: _kLogSource,
        time: DateTime.now(),
        '(${DateTime.now()})refersh token use($refreshToken)');
    final auth = await authRepository.refreshToken(refreshToken: refreshToken);
    if (auth.error == auth_repository.AuthError.none) {
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else if (auth.error == auth_repository.AuthError.tokenExpired ||
        auth.error == auth_repository.AuthError.tokenInvalid) {
      add(_AuthError(auth.error));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    if (change.currentState.status == AuthenticationStatus.unauthenticated &&
        change.nextState.status == AuthenticationStatus.authenticated) {
      log(name: _kLogSource, 'unauthenticated => authenticated');
      _refreshTokenTimerSubscription?.cancel();
      _refreshTokenTimerSubscription =
          Stream<_AuthRefreshTokenTimerIsUp>.periodic(
              Duration(minutes: Config.instance().accessTokenRefreshMinutes),
              (x) => _AuthRefreshTokenTimerIsUp()).listen((event) {
        add(_AuthRefreshTokenTimerIsUp());
      });
      log(name: _kLogSource, 'trigger refresh token timer');
    } else if (change.currentState.status ==
            AuthenticationStatus.authenticated &&
        change.nextState.status == AuthenticationStatus.unauthenticated) {
      log(name: _kLogSource, 'authenticated => unauthenticated');
      _refreshTokenTimerSubscription?.cancel();
      log(name: _kLogSource, 'cancel refresh token timer');
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    return _$AuthStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    log(name: _kLogSource, 'toJson($state)');
    return _$AuthStateToJson(state);
  }
}
