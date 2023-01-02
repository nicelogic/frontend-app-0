import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

import '../models/models.dart';

part 'query_contacts_state.dart';

const _kLogSource = 'QueryContactsCubit';

class QueryContactsCubit extends Cubit<QueryContactsState> {
  final UserRepository userRepository;

  QueryContactsCubit({required this.userRepository})
      : super(const QueryContactsInitial());

  queryContacts({required String idOrName}) async {
    final users = await userRepository.users(idOrName: idOrName);
    if (users.error != UserError.none) {
      emit(QueryContactsState.error(users.error));
    } else {
      List<QueriedContacts> queriedContactsList = [];
      for (var user in users.users.entries) {
        final contacts = QueriedContacts.fromUser(user.value);
        log(name: _kLogSource, 'queried conatcts($contacts)');
        queriedContactsList.add(contacts);
      }
      emit(QueryContactsState(queriedContactsList: queriedContactsList));
    }
  }
}
