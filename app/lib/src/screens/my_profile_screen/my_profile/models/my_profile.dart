import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'my_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class MyProfile extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String signature;
  final UserError error;

  const MyProfile(
      {required this.id,
      required this.name,
      required this.avatarUrl,
      required this.signature,
      this.error = UserError.none});
  const MyProfile.empty()
      : this(id: '', name: '', avatarUrl: '', signature: '');
  MyProfile.fromUser(User user)
      : this(
            id: user.id,
            name: user.name,
            error: user.error,
            avatarUrl: user.avatarUrl,
            signature: user.signature);
  MyProfile copyWith(
      {final String? id,
      final String? name,
      final String? avatarUrl,
      final String? signature,
      final UserError? error}) {
    return MyProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        signature: signature ?? this.signature,
        error: error ?? this.error);
  }

  factory MyProfile.fromJson(Map<String, dynamic> json) =>
      _$MyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$MyProfileToJson(this);

  @override
  List<Object?> get props => [id, name, avatarUrl, signature, error];
}
