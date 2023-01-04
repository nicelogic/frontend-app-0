part of 'add_contacts_applys_cubit.dart';

class AddContactsApplysState extends Equatable {
  final List<AddContactsApply> addContactsApplys;
  final ContactsError error;
  const AddContactsApplysState(
      {required this.addContactsApplys, this.error = ContactsError.none});

  @override
  List<Object> get props => [addContactsApplys, error];
}

AddContactsApplysState fromConnection(AddContactsApplyConnection connection) {
  List<AddContactsApply> addContactsApplys = [];
  for (var edge in connection.edges) {
    addContactsApplys.add(AddContactsApply(
        userId: edge.node.userId,
        message: edge.node.message,
        updateTime: edge.node.updateTime));
  }
  return AddContactsApplysState(
      addContactsApplys: addContactsApplys, error: connection.error);
}

class AddContactsApplysInitial extends AddContactsApplysState {
  AddContactsApplysInitial() : super(addContactsApplys: []);
}
