part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class _AuthOk extends AuthEvent {
  final String token;

  _AuthOk(this.token);
}

class _AuthError extends AuthEvent {
  final AuthError error;

  _AuthError(this.error);
}

class AuthLogoutRequested extends AuthEvent {}
