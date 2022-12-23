import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:app/src/features/auth/auth.dart' as auth;

part 'repositorys_state.dart';

const kLogSource = 'repositorys_cubit';

class RepositorysCubit extends Cubit<RepositorysState> {
  final auth.AuthBloc authBloc;
  final UserRepository userRepository;
  late final StreamSubscription authBlocSubscription;

  RepositorysCubit({required this.authBloc, required this.userRepository})
      : super(RepositorysInitial()) {
    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          log(
              name: kLogSource,
              'auth unauthenticated, update access token empty');
          userRepository.updateToken('');
          break;
        case auth.AuthenticationStatus.authenticated:
          userRepository.updateToken(authState.auth.accessToken);
          log(
              name: kLogSource,
              'auth authenticated data change, new access toke(${authState.auth.accessToken})');
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
