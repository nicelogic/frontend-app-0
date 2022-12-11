part of 'auth_bloc.dart';

@JsonSerializable()
class AuthState extends Equatable {
  final AuthenticationStatus status;
  final String token;
  final auth_repository.AuthError error;
  @override
  List<Object> get props => [status, token];

  const AuthState._({
    this.status = AuthenticationStatus.unauthenticated,
    this.token = '',
    this.error = auth_repository.AuthError.none,
  });
  const AuthState.authInitial() : this._();
  const AuthState.unauthenticated({required auth_repository.AuthError error})
      : this._(error: error);
  const AuthState.authenticated({required String token})
      : this._(status: AuthenticationStatus.authenticated, token: token);

  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState._(
      token: json['token'] as String,
  
    );
  }
}
