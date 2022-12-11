import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import 'package:auth_repository/auth_repository.dart' as auth_repository;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final String authReposiotryUrl;
  final auth_repository.AuthRepository _authRepository;

  AuthBloc({required this.authReposiotryUrl})
      : _authRepository =
            auth_repository.AuthRepository(url: authReposiotryUrl),
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

 Future<auth_repository.Auth> signUpByUserName(
      {required String userName, required String password}) async {
    final auth = await _authRepository.signUpByUserName(
        userName: userName, password: password);
    // add(AuthenticationResultChanged(result));
    return auth;
  }

  Future<auth_repository.Auth> signInByUserName(
      {required String userName, required String password}) async {
    final result = await _authRepository.signInByUserName(
        userName: userName, password: password);
    // add(AuthenticationResultChanged(result));
    return result;
  }

}
