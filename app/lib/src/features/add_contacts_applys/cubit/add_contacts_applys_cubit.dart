import 'dart:developer';

import 'package:app/src/features/auth/auth.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';
import '../models/models.dart';

part 'add_contacts_applys_state.dart';
part 'add_contacts_applys_cubit.g.dart';

const _kLogSource = 'AddContactsApplysCubit';

class AddContactsApplysCubit extends HydratedCubit<AddContactsApplysState> {
  final ContactsRepository contactsRepository;
  final UserRepository userRepository;
  final AuthBloc authBloc;
  AddContactsApplysCubit(
      {required this.contactsRepository,
      required this.userRepository,
      required this.authBloc})
      : super(AddContactsApplysInitial());

  fetchAddContactsApplys() async {
    final connection = await contactsRepository.addContactsApplys(first: 1000);
    final addContactsApplysState = await fromConnection(
        connection: connection,
        userRepository: userRepository,
        userId: authBloc.state.userId);
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
          ?.copyWith(replyAddContactsStatus: ReplyAddContactsStatus.ignore);
      if (addContactsApply != null) {
        addContactsApplys[contactsId] = addContactsApply;
      }
      emit(state.copyWith(addContactsApplys: addContactsApplys));
    } else {
      emit(state.copyWith(error: contactsError));
    }
  }

  @override
  AddContactsApplysState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    final state = _$AddContactsApplysStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: _kLogSource,
        'current userId($userId), cached userId(${state.userId})');
    if (state.userId != userId) {
      return AddContactsApplysInitial();
    } else {
      return state;
    }
  }

  @override
  Map<String, dynamic>? toJson(AddContactsApplysState state) {
    log(name: _kLogSource, 'toJson($state)');
    return _$AddContactsApplysStateToJson(state);
  }
}
