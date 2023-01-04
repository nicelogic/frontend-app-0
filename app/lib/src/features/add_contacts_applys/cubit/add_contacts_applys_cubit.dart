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
    final addContactsApplysState = await fromConnection(
        connection: connection, userRepository: userRepository);
    emit(addContactsApplysState);
  }

  agree({required String contactsId, required String remarkName}) async {
    final contactsError = await contactsRepository.replyAddContacts(
        contactsId: contactsId, isAgree: true, remarkName: remarkName);
    if (contactsError == ContactsError.none) {
      final addContactsApplys = Map.of(state.addContactsApplys);
      final addContactsApply = addContactsApplys[contactsId]
          ?.copyWith(replyAddContactsStatus: ReplyAddContactsStatus.agree);
      if (addContactsApply != null) {
        addContactsApplys[contactsId] = addContactsApply;
      }
      emit(state.copyWith(addContactsApplys: addContactsApplys));
    } else {
      emit(state.copyWith(error: contactsError));
    }
  }

  reject({required String contactsId}) async {
    final contactsError = await contactsRepository.replyAddContacts(
        contactsId: contactsId, isAgree: false, remarkName: '');
    if (contactsError == ContactsError.none) {
      final addContactsApplys = Map.of(state.addContactsApplys);
      final addContactsApply = addContactsApplys[contactsId]
          ?.copyWith(replyAddContactsStatus: ReplyAddContactsStatus.reject);
      if (addContactsApply != null) {
        addContactsApplys[contactsId] = addContactsApply;
      }
      emit(state.copyWith(addContactsApplys: addContactsApplys));
    } else {
      emit(state.copyWith(error: contactsError));
    }
  }
}
