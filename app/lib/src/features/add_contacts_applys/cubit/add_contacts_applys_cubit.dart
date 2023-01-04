import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import '../models/models.dart';

part 'add_contacts_applys_state.dart';

class AddContactsApplysCubit extends Cubit<AddContactsApplysState> {
  final ContactsRepository contactsRepository;
  final UserRepository userRepository;
  AddContactsApplysCubit(
      {required this.contactsRepository, required this.userRepository})
      : super(AddContactsApplysInitial());

  fetchAddContactsApplys() async {
    final connection = await contactsRepository.addContactsApplys(first: 1000);
    final addContactsApplysState = await
        fromConnection(connection: connection, userRepository: userRepository);
    emit(addContactsApplysState);
  }
}
