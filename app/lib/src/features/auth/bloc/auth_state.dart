part of 'auth_bloc.dart';

@JsonSerializable(explicitToJson: true)
class AuthState extends Equatable {
  final AuthenticationStatus status;
  final Auth auth;
  @override
  List<Object> get props => [status, auth];

  const AuthState({
    this.status = AuthenticationStatus.unauthenticated,
    this.auth = const Auth.empty(),
  });
  const AuthState.authInitial() : this();
  AuthState.unauthenticated({required AuthError error})
      : this(auth: Auth.error(error: error));
  AuthState.authenticated(
      {required String refreshToken, required String accessToken})
      : this(
            status: AuthenticationStatus.authenticated,
            auth: Auth.authenticated(
                refreshToken: refreshToken, accessToken: accessToken));
}
