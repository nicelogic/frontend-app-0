// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyProfile _$MyProfileFromJson(Map<String, dynamic> json) => MyProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      signature: json['signature'] as String,
      error: $enumDecodeNullable(_$UserErrorEnumMap, json['error']) ??
          UserError.none,
    );

Map<String, dynamic> _$MyProfileToJson(MyProfile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'signature': instance.signature,
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
