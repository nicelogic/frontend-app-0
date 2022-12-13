part of 'auth_bloc.dart';

@JsonSerializable()
class AuthState extends Equatable {
  final AuthenticationStatus status;
  final String refreshToken;
  final String accessToken;
  final AuthError error;
  @override
  List<Object> get props => [status, refreshToken, accessToken];

  const AuthState({
    this.status = AuthenticationStatus.unauthenticated,
    this.refreshToken = '',
    this.accessToken = '',
    this.error = AuthError.none,
  });
  const AuthState.authInitial() : this();
  const AuthState.unauthenticated({required AuthError error})
      : this(error: error);
  const AuthState.authenticated(
      {required String refreshToken, required String accessToken})
      : this(
            status: AuthenticationStatus.authenticated,
            refreshToken: refreshToken,
            accessToken: accessToken);
}
