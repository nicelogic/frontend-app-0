// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contacts_applys_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddContactsApplysState _$AddContactsApplysStateFromJson(
        Map<String, dynamic> json) =>
    AddContactsApplysState(
      addContactsApplys:
          (json['addContactsApplys'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, AddContactsApply.fromJson(e as Map<String, dynamic>)),
      ),
      error: $enumDecodeNullable(_$ContactsErrorEnumMap, json['error']) ??
          ContactsError.none,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AddContactsApplysStateToJson(
        AddContactsApplysState instance) =>
    <String, dynamic>{
      'addContactsApplys':
          instance.addContactsApplys.map((k, e) => MapEntry(k, e.toJson())),
      'error': _$ContactsErrorEnumMap[instance.error]!,
      'userId': instance.userId,
    };

const _$ContactsErrorEnumMap = {
  ContactsError.none: 'none',
  ContactsError.serverInternalError: 'serverInternalError',
  ContactsError.tokenInvalid: 'tokenInvalid',
  ContactsError.tokenExpired: 'tokenExpired',
  ContactsError.clientInternalError: 'clientInternalError',
  ContactsError.networkError: 'networkError',
  ContactsError.contactsAddedMe: 'contactsAddedMe',
  ContactsError.canNotAddMyselfAsFriend: 'canNotAddMyselfAsFriend',
  ContactsError.invalidContactsId: 'invalidContactsId',
};
