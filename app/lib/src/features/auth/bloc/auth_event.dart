part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class _AuthOk extends AuthEvent {
  final String refreshToken;
  final String accessToken;

  _AuthOk({required this.refreshToken, required this.accessToken});
}

class _AuthError extends AuthEvent {
  final auth_repository.AuthError error;

  _AuthError(this.error);
}

class AuthSignInByUserName extends AuthEvent {
  final String userName;
  final String pwd;

  AuthSignInByUserName(this.userName, this.pwd);
}

class AuthSignUpByUserName extends AuthEvent {
  final String userName;
  final String pwd;

  AuthSignUpByUserName(this.userName, this.pwd);
}

class AuthLogoutRequested extends AuthEvent {}

class _AuthRefreshTokenTimerIsUp extends AuthEvent {}
