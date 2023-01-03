import 'dart:developer';

import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'apply_add_contacts_state.dart';

const _kLogSource = 'ApplyAddContactsCubit';

class ApplyAddContactsCubit extends Cubit<ApplyAddContactsState> {
  final ContactsRepository contactsRepository;
  ApplyAddContactsCubit({required this.contactsRepository})
      : super(const AddContactsInitial());

  applyAddContacts(
      {required String userName,
      required String contactsId,
      required String remarkName,
      required String message}) async {
    final contactsError = await contactsRepository.applyAddContacts(
        userName: userName,
        contactsId: contactsId,
        remarkName: remarkName,
        message: message);
    log(
        name: _kLogSource,
        'applyAddContacts(userName:$userName)(contactsId:$contactsId)(remarkName:$remarkName)(message:$message), result($contactsError)');
    emit(ApplyAddContactsState(
        error: contactsError,
        applyAddContactsSuccess: contactsError == ContactsError.none));
  }
}
