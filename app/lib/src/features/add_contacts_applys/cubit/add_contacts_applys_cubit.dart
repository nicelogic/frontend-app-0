import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/models.dart';

part 'add_contacts_applys_state.dart';

class AddContactsApplysCubit extends Cubit<AddContactsApplysState> {
  final ContactsRepository contactsRepository;
  AddContactsApplysCubit({required this.contactsRepository})
      : super(AddContactsApplysInitial());

  fetchAddContactsApplys() async {
    final connection = contactsRepository.addContactsApplys(first: 1000);
  }
}
