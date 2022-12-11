part of 'auth_bloc.dart';


@JsonSerializable()
class AuthState extends Equatable {
  final AuthenticationStatus status;
  final String token;
  final AuthError error;
  @override
  List<Object> get props => [status, token];

  const AuthState({
    this.status = AuthenticationStatus.unauthenticated,
    this.token = '',
    this.error = AuthError.none,
  });
  const AuthState.authInitial() : this();
  const AuthState.unauthenticated({required AuthError error})
      : this(error: error);
  const AuthState.authenticated({required String token})
      : this(status: AuthenticationStatus.authenticated, token: token);
}
