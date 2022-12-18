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
  AuthState.unauthenticated({required auth_repository.AuthError error})
      : this(auth: AuthInfo.error(error: error));
  AuthState.authenticated(
      {required String refreshToken, required String accessToken})
      : this(
            status: AuthenticationStatus.authenticated,
            auth: AuthInfo.authenticated(
                refreshToken: refreshToken, accessToken: accessToken));
}

Map<String, dynamic> _decodePayload(String token) {
  final splitToken = token.split("."); // Split the token by '.'
  if (splitToken.length != 3) {
    throw const FormatException('Invalid token');
  }
  try {
    final payloadBase64 = splitToken[1]; // Payload is always the index 1
    // Base64 should be multiple of 4. Normalize the payload before decode it
    final normalizedPayload = base64.normalize(payloadBase64);
    // Decode payload, the result is a String
    final payloadString = utf8.decode(base64.decode(normalizedPayload));
    // Parse the String to a Map<String, dynamic>
    final decodedPayload = jsonDecode(payloadString);

    // Return the decoded payload
    return decodedPayload;
  } catch (error) {
    throw const FormatException('Invalid payload');
  }
}

extension UserId on AuthState {
  String get userId {
    if (auth.refreshToken.isNotEmpty) {
      Map<String, dynamic> decodedPayload = _decodePayload(auth.refreshToken);
      final userId = decodedPayload['user']['id'] as String;
      return userId;
    } else {
      return '';
    }
  }
}
