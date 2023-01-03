// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsState _$ContactsStateFromJson(Map<String, dynamic> json) =>
    ContactsState(
      userId: json['userId'] as String,
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => Contacts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactsStateToJson(ContactsState instance) =>
    <String, dynamic>{
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };
