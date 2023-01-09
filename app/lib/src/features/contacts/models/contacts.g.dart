// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contacts _$ContactsFromJson(Map<String, dynamic> json) => Contacts(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$ContactsToJson(Contacts instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };

ContactsPageKey _$ContactsPageKeyFromJson(Map<String, dynamic> json) =>
    ContactsPageKey(
      pageIndex: json['pageIndex'] as int,
      pageCursor: json['pageCursor'] as String,
    );

Map<String, dynamic> _$ContactsPageKeyToJson(ContactsPageKey instance) =>
    <String, dynamic>{
      'pageIndex': instance.pageIndex,
      'pageCursor': instance.pageCursor,
    };

PagedContacts _$PagedContactsFromJson(Map<String, dynamic> json) =>
    PagedContacts(
      pageKey:
          ContactsPageKey.fromJson(json['pageKey'] as Map<String, dynamic>),
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => Contacts.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageKey: json['nextPageKey'] == null
          ? null
          : ContactsPageKey.fromJson(
              json['nextPageKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagedContactsToJson(PagedContacts instance) =>
    <String, dynamic>{
      'pageKey': instance.pageKey.toJson(),
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
      'nextPageKey': instance.nextPageKey?.toJson(),
    };
