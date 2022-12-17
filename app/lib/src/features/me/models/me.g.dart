// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) => Me(
      id: json['id'] as String,
      name: json['name'] as String,
      data: json['data'] as String,
      error: $enumDecodeNullable(_$UserErrorEnumMap, json['error']) ??
          UserError.none,
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'data': instance.data,
      'error': _$UserErrorEnumMap[instance.error]!,
    };

const _$UserErrorEnumMap = {
  UserError.none: 'none',
  UserError.serverInternalError: 'serverInternalError',
  UserError.userNotExist: 'userNotExist',
  UserError.tokenInvalid: 'tokenInvalid',
  UserError.tokenExpired: 'tokenExpired',
  UserError.clientInternalError: 'clientInternalError',
  UserError.networkError: 'networkError',
};
