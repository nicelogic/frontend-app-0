part of 'contacts_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ContactsState extends Equatable {
  @JsonKey(ignore: true)
  final Connection? contactsConnection;
  final List<Contacts> contacts;
  final String userId;
  const ContactsState(
      {required this.userId, this.contactsConnection, required this.contacts});

  @override
  List<Object> get props => [contacts];
}

class ContactsInitial extends ContactsState {
  const ContactsInitial(
      {required super.userId,
      required super.contactsConnection,
      required super.contacts});
}
