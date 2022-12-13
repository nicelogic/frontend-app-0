import 'error.dart';

class Auth {
  final String accessToken;
  final String refreshToken;
  final AuthError error;

  const Auth(
      {this.refreshToken = '',
      this.accessToken = '',
      this.error = AuthError.none});
}
