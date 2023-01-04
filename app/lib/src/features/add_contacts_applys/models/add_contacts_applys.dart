import 'package:equatable/equatable.dart';

class AddContactsApply extends Equatable {
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String message;
  final DateTime updateTime;

  const AddContactsApply(
      {required this.userId, 
      required this.userName,
      required this.userAvatarUrl,
      required this.message,
      required this.updateTime});

  @override
  List<Object?> get props =>
      [userId, userName, userAvatarUrl, message, updateTime];
}
