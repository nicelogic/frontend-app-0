part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class _AuthOk extends AuthEvent {
  final String refreshToken;
  final String accessToken;

  _AuthOk({required this.refreshToken, required this.accessToken});
}

class _AuthError extends AuthEvent {
  final AuthError error;

  _AuthError(this.error);
}

class AuthLogoutRequested extends AuthEvent {}
