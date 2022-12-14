part of 'add_contacts_applys_cubit.dart';

@JsonSerializable(explicitToJson: true)
class AddContactsApplysState extends Equatable {
  final Map<String, AddContactsApply> addContactsApplys;
  final ContactsError error;
  final String userId;
  const AddContactsApplysState(
      {required this.addContactsApplys,
      this.error = ContactsError.none,
      required this.userId});

  AddContactsApplysState copyWith(
      {final Map<String, AddContactsApply>? addContactsApplys,
      final ContactsError? error}) {
    return AddContactsApplysState(
        addContactsApplys: addContactsApplys ?? this.addContactsApplys,
        error: error ?? this.error,
        userId: userId);
  }

  @override
  List<Object> get props => [addContactsApplys, error];
}

Future<AddContactsApplysState> fromConnection(
    {required AddContactsApplyConnection connection,
    required UserRepository userRepository,
    required String userId}) async {
  Map<String, AddContactsApply> addContactsApplys = {};
  var error = connection.error;
  if (error != ContactsError.none) {
    return AddContactsApplysState(
        addContactsApplys: const <String, AddContactsApply>{},
        error: error,
        userId: userId);
  }
  for (var edge in connection.edges) {
    final users = await userRepository.users(idOrName: edge.node.userId);
    if (users.error != UserError.none) {
      error = ContactsError.clientInternalError;
      return AddContactsApplysState(
          addContactsApplys: const {}, error: error, userId: userId);
    }
    if (users.users.isNotEmpty) {
      final user = users.users.entries.elementAt(0).value;
      addContactsApplys[user.id] = AddContactsApply(
          userId: user.id,
          userName: user.name,
          userAvatarUrl: user.avatarUrl,
          message: edge.node.message,
          updateTime: edge.node.updateTime,
          replyAddContactsStatus: ReplyAddContactsStatus.none);
    } else {
      addContactsApplys[edge.node.userId] = AddContactsApply(
          userId: edge.node.userId,
          userName: '',
          userAvatarUrl: '',
          message: edge.node.message,
          updateTime: edge.node.updateTime,
          replyAddContactsStatus: ReplyAddContactsStatus.none);
    }
  }
  return AddContactsApplysState(
      addContactsApplys: addContactsApplys, error: error, userId: userId);
}

class AddContactsApplysInitial extends AddContactsApplysState {
  AddContactsApplysInitial() : super(addContactsApplys: {}, userId: '');
}
