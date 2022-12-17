part of 'auth_bloc.dart';

@JsonSerializable(explicitToJson: true)
class AuthState extends Equatable {
  final AuthenticationStatus status;
  final AuthInfo auth;
  @override
  List<Object> get props => [status, auth];

  const AuthState({
    this.status = AuthenticationStatus.unauthenticated,
    this.auth = const AuthInfo.empty(),
  });
  const AuthState.authInitial() : this();
  AuthState.unauthenticated({required AuthError error})
      : this(auth: AuthInfo.error(error: error));
  AuthState.authenticated(
      {required String refreshToken, required String accessToken})
      : this(
            status: AuthenticationStatus.authenticated,
            auth: AuthInfo.authenticated(
                refreshToken: refreshToken, accessToken: accessToken));
}
