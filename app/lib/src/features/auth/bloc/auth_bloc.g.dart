// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      status:
          $enumDecodeNullable(_$AuthenticationStatusEnumMap, json['status']) ??
              AuthenticationStatus.unauthenticated,
      token: json['token'] as String? ?? '',
      error: $enumDecodeNullable(_$AuthErrorEnumMap, json['error']) ??
          AuthError.none,
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'status': _$AuthenticationStatusEnumMap[instance.status]!,
      'token': instance.token,
      'error': _$AuthErrorEnumMap[instance.error]!,
    };

const _$AuthenticationStatusEnumMap = {
  AuthenticationStatus.authenticated: 'authenticated',
  AuthenticationStatus.unauthenticated: 'unauthenticated',
};

const _$AuthErrorEnumMap = {
  AuthError.none: 'none',
  AuthError.serverInternalError: 'serverInternalError',
  AuthError.clientInternalError: 'clientInternalError',
  AuthError.networkError: 'networkError',
  AuthError.userExist: 'userExist',
  AuthError.userNotExist: 'userNotExist',
  AuthError.pwdWrong: 'pwdWrong',
};
