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
