part of 'add_contacts_applys_cubit.dart';

class AddContactsApplysState extends Equatable {
  final List<AddContactsApply> addContactsApplys;
  final ContactsError error;
  const AddContactsApplysState(
      {required this.addContactsApplys, this.error = ContactsError.none});

  @override
  List<Object> get props => [addContactsApplys, error];
}

Future<AddContactsApplysState> fromConnection(
    {required AddContactsApplyConnection connection,
    required UserRepository userRepository}) async {
  List<AddContactsApply> addContactsApplys = [];
  var error = connection.error;
  if (error != ContactsError.none) {
    return AddContactsApplysState(addContactsApplys: const [], error: error);
  }
  for (var edge in connection.edges) {
    final users = await userRepository.users(idOrName: edge.node.userId);
    if (users.error != UserError.none) {
      error = ContactsError.clientInternalError;
      return AddContactsApplysState(addContactsApplys: const [], error: error);
    }
    if (users.users.isNotEmpty) {
      final user = users.users.entries.elementAt(0).value;
      addContactsApplys.add(AddContactsApply(
          userId: edge.node.userId,
          userName: user.name,
          userAvatarUrl: user.avatarUrl,
          message: edge.node.message,
          updateTime: edge.node.updateTime));
    }
  }
  return AddContactsApplysState(
      addContactsApplys: addContactsApplys, error: error);
}

class AddContactsApplysInitial extends AddContactsApplysState {
  AddContactsApplysInitial() : super(addContactsApplys: []);
}
