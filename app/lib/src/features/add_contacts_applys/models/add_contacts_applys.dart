import 'package:equatable/equatable.dart';

class AddContactsApply extends Equatable {
  final String userId;
  final String contactsId;
  final String message;
  final DateTime updateTime;

  const AddContactsApply(
      {required this.userId,
      required this.contactsId,
      required this.message,
      required this.updateTime});

  @override
  List<Object?> get props => [userId, contactsId, message, updateTime];
}
