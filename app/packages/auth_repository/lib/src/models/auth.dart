import 'package:json_annotation/json_annotation.dart';

import 'error.dart';

part 'auth.g.dart';

@JsonSerializable(explicitToJson: true)
class Auth {
  final String accessToken;
  final String refreshToken;
  final AuthError error;

  const Auth(
      {this.refreshToken = '',
      this.accessToken = '',
      this.error = AuthError.none});
  const Auth.empty() : this();
  const Auth.error({required AuthError error}) : this(error: error);
  const Auth.authenticated(
      {required String refreshToken, required String accessToken})
      : this(refreshToken: refreshToken, accessToken: accessToken);

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
