import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contacts.g.dart';

@JsonSerializable(explicitToJson: true)
class Contacts extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;

  const Contacts(
      {required this.id, required this.name, required this.avatarUrl});

  @override
  List<Object?> get props => [id, name, avatarUrl];

  factory Contacts.fromJson(Map<String, dynamic> json) =>
      _$ContactsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ContactsPageKey extends Equatable {
  final int pageIndex;
  final String pageCursor;

  const ContactsPageKey({required this.pageIndex, required this.pageCursor});

  @override
  List<Object> get props => [pageIndex, pageCursor];

  @override
  bool get stringify => true;

  factory ContactsPageKey.fromJson(Map<String, dynamic> json) =>
      _$ContactsPageKeyFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsPageKeyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PagedContacts extends Equatable {
  final ContactsPageKey pageKey;
  final List<Contacts> contacts;
  final ContactsPageKey? nextPageKey;

  const PagedContacts(
      {required this.pageKey,
      required this.contacts,
      required this.nextPageKey});

  @override
  List<Object?> get props => [pageKey, contacts, nextPageKey];

  factory PagedContacts.fromJson(Map<String, dynamic> json) =>
      _$PagedContactsFromJson(json);
  Map<String, dynamic> toJson() => _$PagedContactsToJson(this);

  @override
  bool get stringify => true;

  String toSimpleString() {
    return 'PagedContacts{pageKey($pageKey), nextPageKey($nextPageKey), contactsNum(${contacts.length})}';
  }
}
