part of 'apply_add_contacts_cubit.dart';

class ApplyAddContactsState extends Equatable {
  final ContactsError error;
  final bool applyAddContactsSuccess;
  const ApplyAddContactsState(
      {required this.error, required this.applyAddContactsSuccess});

  @override
  List<Object> get props => [error];
}

class AddContactsInitial extends ApplyAddContactsState {
  const AddContactsInitial()
      : super(error: ContactsError.none, applyAddContactsSuccess: false);
}
