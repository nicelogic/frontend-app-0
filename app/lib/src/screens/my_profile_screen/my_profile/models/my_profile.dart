import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'my_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class MyProfile extends Equatable {
  final String id;
  final String name;
  final String data;
  final UserError error;

  const MyProfile(
      {required this.id,
      required this.name,
      required this.data,
      this.error = UserError.none});
  const MyProfile.empty() : this(id: '', name: '', data: '');
  MyProfile.fromUser(User user)
      : this(id: user.id, name: user.name, data: user.data, error: user.error);

  factory MyProfile.fromJson(Map<String, dynamic> json) =>
      _$MyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$MyProfileToJson(this);

  @override
  List<Object?> get props => [id, name, data, error];
}
