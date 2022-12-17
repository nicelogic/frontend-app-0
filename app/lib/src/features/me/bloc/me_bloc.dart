import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:app/src/features/auth/auth.dart' as auth;

part 'me_event.dart';
part 'me_state.dart';

const kLogSource = 'MeBloc';

class MeBloc extends HydratedBloc<MeEvent, MeState> {
  final UserRepository userRepository;
  final auth.AuthBloc authBloc;
  late final StreamSubscription authBlocSubscription;

  MeBloc(this.userRepository, this.authBloc)
      : super(const MeState.meInitial()) {
    on<_MeFetched>(_onMeFetched);
    on<_Logout>(_onLogout);

    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          add(_Logout());
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

  _onMeFetched(_MeFetched event, emit) async {
    emit(event.me);
  }

  _onLogout(_Logout event, emit) async {
    emit(const MeState.meInitial());
  }

  @override
  MeState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(MeState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  me() async {
    final me = await userRepository.me();
    add(_MeFetched(me));
  }
}
