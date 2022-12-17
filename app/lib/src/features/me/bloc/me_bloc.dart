import 'dart:async';

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

  MeBloc(this.userRepository, this.authBloc) : super(const MeInitial()) {
    on<_MeFetched>(_onMyDataFetched);
    on<_Logout>(_onLogout);

    authBlocSubscription = authBloc.stream.listen((authState) {
      switch (authState.status) {
        case auth.AuthenticationStatus.unauthenticated:
          //clear user state
          break;
        case auth.AuthenticationStatus.authenticated:
          userRepository.updateToken(authState.accessToken);
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

  _onMyDataFetched(_MeFetched event, emit) async {
    emit(event.me);
  }

  _onLogout(_Logout event, emit) async {
    emit(const Me(User.empty()));
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
    add(_MeFetched(Me(me)));
  }
}
