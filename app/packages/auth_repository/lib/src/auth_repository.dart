import 'dart:async';

import 'api_client.dart';
import 'models/models.dart' as models;

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required String url})
      : _apiClient = ApiClient.create(url: url);

  Future<models.Auth> signUpByUserName(
      {required String userName, required String password}) async {
    final result = await _apiClient.signUpByUserName(
        userName: userName, password: password);
    return result;
  }

  Future<models.Auth> signInByUserName(
      {required String userName, required String password}) async {
    final result = await _apiClient.signInByUserName(
        userName: userName, password: password);
    return result;
  }

  Future<models.Auth> refreshToken({required String refreshToken}) async {
    final result =
        await _apiClient.refreshToken(refreshToken: refreshToken);
    return result;
  }
}
