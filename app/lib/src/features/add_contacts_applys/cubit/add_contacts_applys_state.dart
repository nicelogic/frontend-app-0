part of 'add_contacts_applys_cubit.dart';

class AddContactsApplysState extends Equatable {
  final List<AddContactsApply> addContactsApplys;
  final ContactsError error;
  const AddContactsApplysState(
      {required this.addContactsApplys, this.error = ContactsError.none});

  @override
  List<Object> get props => [];
}

class AddContactsApplysInitial extends AddContactsApplysState {
  AddContactsApplysInitial() : super(addContactsApplys: []);
}
