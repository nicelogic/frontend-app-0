import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_info.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthInfo extends Equatable {
  final String refreshToken;
  final String accessToken;
  final AuthError error;

  const AuthInfo(
      {this.refreshToken = '',
      this.accessToken = '',
      this.error = AuthError.none});
  const AuthInfo.empty() : this();
  const AuthInfo.error({required AuthError error}) : this(error: error);
  const AuthInfo.authenticated(
      {required String refreshToken, required String accessToken})
      : this(refreshToken: refreshToken, accessToken: accessToken);

  factory AuthInfo.fromJson(Map<String, dynamic> json) =>
      _$AuthInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthInfoToJson(this);
  
  @override
  List<Object?> get props => [refreshToken, accessToken, error];
}
