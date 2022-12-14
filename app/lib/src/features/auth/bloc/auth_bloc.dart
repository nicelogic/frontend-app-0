import 'dart:async';
import 'dart:developer';

import 'package:app/src/config/config.dart';
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
  StreamSubscription<_AuthRefreshTokenTimerIsUp>?
      _refreshTokenTimerSubscription;

  AuthBloc({required this.authReposiotryUrl})
      : _authRepository = AuthRepository(url: authReposiotryUrl),
        super(const AuthState.authInitial()) {
    on<_AuthOk>(_onAuthOk);
    on<_AuthError>(_onAuthError);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<_AuthRefreshTokenTimerIsUp>(_onAuthRefreshTokenTimerIsUp);

    if (state.status == AuthenticationStatus.authenticated) {
      log(
          name: kLogSource,
          time: DateTime.now(),
          'authenticated, start to refresh access & refresh token and triger timer to auto refressh');
      add(_AuthRefreshTokenTimerIsUp());
      _refreshTokenTimerSubscription =
          Stream<_AuthRefreshTokenTimerIsUp>.periodic(
              Duration(minutes: Config.instance().accessTokenRefreshMinutes),
              (x) => _AuthRefreshTokenTimerIsUp()).listen((event) {
        add(_AuthRefreshTokenTimerIsUp());
      });
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
    emit(const AuthState.unauthenticated(error: AuthError.none));
  }

  _onAuthRefreshTokenTimerIsUp(
      _AuthRefreshTokenTimerIsUp event, Emitter<AuthState> emit) async {
    final refreshToken = state.refreshToken;
    log(
        name: kLogSource,
        time: DateTime.now(),
        'refersh token use($refreshToken)');
    final auth = await _authRepository.refreshToken(refreshToken: refreshToken);
    if (auth.error == AuthError.none) {
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else if (auth.error == AuthError.tokenExpired ||
        auth.error == AuthError.tokenInvalid) {
      add(_AuthError(auth.error));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    if (change.currentState.status == AuthenticationStatus.unauthenticated &&
        change.nextState.status == AuthenticationStatus.authenticated) {
      log(name: kLogSource, 'unauthenticated => authenticated');
      _refreshTokenTimerSubscription?.cancel();
      _refreshTokenTimerSubscription =
          Stream<_AuthRefreshTokenTimerIsUp>.periodic(
              Duration(minutes: Config.instance().accessTokenRefreshMinutes),
              (x) => _AuthRefreshTokenTimerIsUp()).listen((event) {
        add(_AuthRefreshTokenTimerIsUp());
      });
      log(name: kLogSource, 'trigger refresh token timer');
    } else if (change.currentState.status ==
            AuthenticationStatus.authenticated &&
        change.nextState.status == AuthenticationStatus.unauthenticated) {
      log(name: kLogSource, 'authenticated => unauthenticated');
      _refreshTokenTimerSubscription?.cancel();
      log(name: kLogSource, 'cancel refresh token timer');
    }
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
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else {
      add(_AuthError(auth.error));
    }
  }

  Future<void> signInByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signInByUserName(
        userName: userName, password: password);
    if (auth.error == AuthError.none) {
      add(_AuthOk(
          refreshToken: auth.refreshToken, accessToken: auth.accessToken));
    } else {
      add(_AuthError(auth.error));
    }
  }
}
