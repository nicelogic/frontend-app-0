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
      print('token: ${auth.refreshToken}');
    }
  });
}
