import 'error.dart';

class Auth {
  final String accessToken;
  final String refreshToken;
  final AuthError error;

  const Auth._(
      {this.refreshToken = '',
      this.accessToken = '',
      this.error = AuthError.none});
  const Auth.error({required AuthError error}) : this._(error: error);
  const Auth.authenticated(
      {required String refreshToken, required String accessToken})
      : this._(refreshToken: refreshToken, accessToken: accessToken);
}
