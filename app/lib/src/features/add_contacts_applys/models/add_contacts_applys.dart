import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_contacts_applys.g.dart';

enum ReplyAddContactsStatus {
  none,
  agree,
  ignore,
}

@JsonSerializable(explicitToJson: true)
class AddContactsApply extends Equatable {
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String message;
  final DateTime updateTime;
  final ReplyAddContactsStatus replyAddContactsStatus;

  const AddContactsApply(
      {required this.userId,
      required this.userName,
      required this.userAvatarUrl,
      required this.message,
      required this.updateTime,
      required this.replyAddContactsStatus});
  AddContactsApply copyWith(
      {final String? userId,
      final String? userName,
      final String? userAvatarUrl,
      final String? message,
      final DateTime? updateTime,
      final ReplyAddContactsStatus? replyAddContactsStatus}) {
    return AddContactsApply(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
        message: message ?? this.message,
        updateTime: updateTime ?? this.updateTime,
        replyAddContactsStatus:
            replyAddContactsStatus ?? this.replyAddContactsStatus);
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        userAvatarUrl,
        message,
        updateTime,
        replyAddContactsStatus
      ];

  factory AddContactsApply.fromJson(Map<String, dynamic> json) =>
      _$AddContactsApplyFromJson(json);
  Map<String, dynamic> toJson() => _$AddContactsApplyToJson(this);
}
