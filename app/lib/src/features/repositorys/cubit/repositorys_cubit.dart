import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:contacts_repository/contacts_repository.dart'
    as contacts_repository;
import 'package:app/src/features/auth/auth.dart' as auth;

part 'repositorys_state.dart';

const _kLogSource = 'repositorys_cubit';

class RepositorysCubit extends Cubit<RepositorysState> {
  final auth.AuthBloc authBloc;
  final user_repository.UserRepository userRepository;
  final contacts_repository.ContactsRepository contactsRepository;
  late final StreamSubscription authBlocSubscription;

  RepositorysCubit(
      {required this.authBloc,
      required this.userRepository,
      required this.contactsRepository})
      : super(RepositorysInitial()) {
    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          log(
              name: _kLogSource,
              'auth unauthenticated, all repositorys update access token empty');
          userRepository.updateToken('');
          contactsRepository.updateToken('');
          break;
        case auth.AuthenticationStatus.authenticated:
          final accessToken = authState.auth.accessToken;
          userRepository.updateToken(accessToken);
          contactsRepository.updateToken(accessToken);
          log(
              name: _kLogSource,
              'auth authenticated data change, new access toke(${authState.auth.accessToken}), all repositorys update token');
          break;
        default:
      }
    });
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
