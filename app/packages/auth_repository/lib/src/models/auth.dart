import 'error.dart';

class Auth {
  final String token;
  final AuthError error;

  const Auth({this.token = '', this.error = AuthError.none});
}
