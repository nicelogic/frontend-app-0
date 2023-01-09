// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsState _$ContactsStateFromJson(Map<String, dynamic> json) =>
    ContactsState(
      userId: json['userId'] as String,
      cachedContacts: (json['cachedContacts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), PagedContacts.fromJson(e as Map<String, dynamic>)),
      ),
      error: $enumDecode(_$ContactsErrorEnumMap, json['error']),
    );

Map<String, dynamic> _$ContactsStateToJson(ContactsState instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'cachedContacts': instance.cachedContacts
          .map((k, e) => MapEntry(k.toString(), e.toJson())),
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
