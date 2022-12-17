// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthInfo _$AuthInfoFromJson(Map<String, dynamic> json) => AuthInfo(
      refreshToken: json['refreshToken'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      error: $enumDecodeNullable(_$AuthErrorEnumMap, json['error']) ??
          AuthError.none,
    );

Map<String, dynamic> _$AuthInfoToJson(AuthInfo instance) => <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'accessToken': instance.accessToken,
      'error': _$AuthErrorEnumMap[instance.error]!,
    };

const _$AuthErrorEnumMap = {
  AuthError.none: 'none',
  AuthError.serverInternalError: 'serverInternalError',
  AuthError.clientInternalError: 'clientInternalError',
  AuthError.networkError: 'networkError',
  AuthError.userExist: 'userExist',
  AuthError.userNotExist: 'userNotExist',
  AuthError.pwdWrong: 'pwdWrong',
  AuthError.tokenInvalid: 'tokenInvalid',
  AuthError.tokenExpired: 'tokenExpired',
};
