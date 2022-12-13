import 'dart:async';

import 'api_client.dart';
import 'models/models.dart' as models;

class AuthRepository {
  final AuthApiClient _authenticationApiClient;

  AuthRepository({required String url})
      : _authenticationApiClient = AuthApiClient.create(url: url);

  Future<models.Auth> signUpByUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationApiClient.signUpByUserName(
        userName: userName, password: password);
    return result;
  }

  Future<models.Auth> signInByUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationApiClient.signInByUserName(
        userName: userName, password: password);
    return result;
  }

  Future<models.Auth> refreshToken({required String refreshToken}) async {
    final result =
        await _authenticationApiClient.refreshToken(refreshToken: refreshToken);
    return result;
  }
}
