// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsState _$ContactsStateFromJson(Map<String, dynamic> json) =>
    ContactsState(
      userId: json['userId'] as String,
      cachedContacts: (json['cachedContacts'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => Contacts.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      nextPageIndex: json['nextPageIndex'] as int?,
      error: $enumDecode(_$ContactsErrorEnumMap, json['error']),
    );

Map<String, dynamic> _$ContactsStateToJson(ContactsState instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'cachedContacts': instance.cachedContacts
          .map((e) => e.map((e) => e.toJson()).toList())
          .toList(),
      'nextPageIndex': instance.nextPageIndex,
      'error': _$ContactsErrorEnumMap[instance.error]!,
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
