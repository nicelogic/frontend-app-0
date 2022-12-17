// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
      refreshToken: json['refreshToken'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      error: $enumDecodeNullable(_$AuthErrorEnumMap, json['error']) ??
          AuthError.none,
    );

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
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
