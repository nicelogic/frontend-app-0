
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_repository/auth_repository.dart' as auth_repository;

void main() {
  test('auth repository', () async {
    final authRepository = auth_repository.AuthRepository(
        url: 'https://auth.app0.env0.luojm.com:9443/query');
    final auth =
        await authRepository.signInByUserName(userName: 'test', password: 'c');
    expect(auth.error, auth_repository.AuthError.none);
    expect(auth.refreshToken.isEmpty, false);
    if (kDebugMode) {
      print('sign in result: refresh token: ${auth.refreshToken}');
      print('sign in result: access token: ${auth.accessToken}');
    }

    final refreshTokenResult =
        await authRepository.refreshToken(refreshToken: auth.refreshToken);
    expect(refreshTokenResult.refreshToken.isEmpty, false);
    if (kDebugMode) {
      print(
          'refresh token result: refresh token: ${refreshTokenResult.refreshToken}');
      print(
          'refresh token result: access token: ${refreshTokenResult.accessToken}');
    }
  });

  test('auth repository sign up by user name', () async {
    final authRepository = auth_repository.AuthRepository(
        url: 'https://auth.app0.env0.luojm.com:9443/query');
    final auth =
        await authRepository.signUpByUserName(userName: 'test6', password: 'c');
    expect(auth.error, auth_repository.AuthError.none);
    expect(auth.refreshToken.isEmpty, false);
    if (kDebugMode) {
      print('sign in result: refresh token: ${auth.refreshToken}');
      print('sign in result: access token: ${auth.accessToken}');
    }
  });
}
