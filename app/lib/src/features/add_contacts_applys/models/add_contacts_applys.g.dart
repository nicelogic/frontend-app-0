// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contacts_applys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddContactsApply _$AddContactsApplyFromJson(Map<String, dynamic> json) =>
    AddContactsApply(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      message: json['message'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
      replyAddContactsStatus: $enumDecode(
          _$ReplyAddContactsStatusEnumMap, json['replyAddContactsStatus']),
    );

Map<String, dynamic> _$AddContactsApplyToJson(AddContactsApply instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'message': instance.message,
      'updateTime': instance.updateTime.toIso8601String(),
      'replyAddContactsStatus':
          _$ReplyAddContactsStatusEnumMap[instance.replyAddContactsStatus]!,
    };

const _$ReplyAddContactsStatusEnumMap = {
  ReplyAddContactsStatus.none: 'none',
  ReplyAddContactsStatus.agree: 'agree',
  ReplyAddContactsStatus.ignore: 'ignore',
};
