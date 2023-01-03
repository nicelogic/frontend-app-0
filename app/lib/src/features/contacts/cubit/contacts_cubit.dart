import 'dart:developer';

import 'package:contacts_repository/contacts_repository.dart'
    as contacts_repository;
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/models.dart';

part 'contacts_state.dart';
part 'contacts_cubit.g.dart';

const _kLogSource = 'ContactsCubit';

class ContactsCubit extends HydratedCubit<ContactsState> {
  final contacts_repository.ContactsRepository contactsRepository;
  final auth.AuthBloc authBloc;

  ContactsCubit({required this.contactsRepository, required this.authBloc})
      : super(ContactsInitial(
            userId: authBloc.state.userId,
            contactsConnection: const Connection(
                totalCount: 0, pageInfo: PageInfo('', false), edges: []),
            contacts: const []));

  fetchContacts({required int first, String? after}) async {
    final contactsConnection =
        await contactsRepository.contacts(first: first, after: after);
    final curConnection = Connection.fromContactsConnection(contactsConnection);
    log(name: _kLogSource, 'connection($curConnection)');
    // state.contacts.add(contactsConnection.edges.)
    emit(ContactsState(
        userId: authBloc.state.userId,
        contactsConnection: curConnection,
        contacts: const []));
  }

  @override
  ContactsState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    final state = _$ContactsStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: _kLogSource,
        'current userId($userId), cached userId(${state.userId})');
    if (state.userId != userId) {
      return ContactsInitial(
          userId: authBloc.state.userId,
          contactsConnection: const Connection(
              totalCount: 0, pageInfo: PageInfo('', false), edges: []),
          contacts: const []);
    } else {
      return state;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContactsState state) {
    log(name: _kLogSource, 'toJson($state)');
    return _$ContactsStateToJson(state);
  }
}
