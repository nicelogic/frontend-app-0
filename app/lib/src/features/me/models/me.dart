import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'me.g.dart';

@JsonSerializable(explicitToJson: true)
class Me {
  final String id;
  final String name;
  final String data;
  final UserError error;

  Me(
      {required this.id,
      required this.name,
      required this.data,
      this.error = UserError.none});
  Me.empty() : this(id: '', name: '', data: '');
  Me.fromUser(User user)
      : this(id: user.id, name: user.name, data: user.data, error: user.error);

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);
  Map<String, dynamic> toJson() => _$MeToJson(this);
}
