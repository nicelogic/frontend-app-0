import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:user_repository/user_repository.dart';

void main() {
  test('user repository me', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI1MTE4NzMsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.AyGPuB0P7jjAdvEHY_uA6OyNvbXa_tv2HXXaOoIhYrzbv-JjiDf8XPmjTY4EejqGdRXfHY21gPwdXq34uM8XsL5L0lQPz77Eu4NCmR_wy0FeVDpq3ZljP4xCat7oBOSZ-U-IsAtoxwXkloTeTQAbnmOQUou83RR9kuPFQb91-oof3iPOsRblE8Y2kqKuGjbRQVhbSpvjo6-AWzvEtugXynDlhQ0pbOTI2mKwaOnMOOY4xnRA4oU3i-09XTIFnJeVyM-dfEJ2NzHhOHBSBEbfaKz2sJSN4gwUJ5DubZWS3r6PlvuCe5p9UOkWVAJh981MKv52UDxxKmoLn28n5nkkEQ');
    final user = await userRepository.me();
    if (kDebugMode) {
      print('user id(${user.id}),name(${user.name}), data(${user.data}');
    }
    expect(user.name, 'test1test');
  });

  test('user repository users', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg4OTU5MjMsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.cGOHCHG5usUlL53DmpQxScHZiNYWDA-BWYYaO7Fk2iCIGXyhlavxNEonUDmDQKnTDltrlHIbWoraKWl9Ort-fpNkTLnk041TxU12PI9Mv4HADMMqJQ_r0574y5GDlBD5ru6xzqonGIsBECACoK0zxShMIJ3LE_jPb8ZDbGZzLHfeWWffK3Fo1dJ3wR9IAAZZAum3wfnnYZjRyZg2KYA9sNPbKwMHLnrsDpcdohI5SJinYp63v8kq_zJumiOJQJ209EHBRsip3g6HisHMZttMNxi_iMEsoLZtIMbh0tkFPkTN_K7qXe6Ic8GXD5Pn1cxWr7MLJ6O-qlzTX8q9T3dYHQ');
    final users = await userRepository.users(idOrName: 'test');
    expect(users.error, UserError.none);
  });

  test('user repository updateUser', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg4OTU5MjMsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.cGOHCHG5usUlL53DmpQxScHZiNYWDA-BWYYaO7Fk2iCIGXyhlavxNEonUDmDQKnTDltrlHIbWoraKWl9Ort-fpNkTLnk041TxU12PI9Mv4HADMMqJQ_r0574y5GDlBD5ru6xzqonGIsBECACoK0zxShMIJ3LE_jPb8ZDbGZzLHfeWWffK3Fo1dJ3wR9IAAZZAum3wfnnYZjRyZg2KYA9sNPbKwMHLnrsDpcdohI5SJinYp63v8kq_zJumiOJQJ209EHBRsip3g6HisHMZttMNxi_iMEsoLZtIMbh0tkFPkTN_K7qXe6Ic8GXD5Pn1cxWr7MLJ6O-qlzTX8q9T3dYHQ');
    var updateUser = await userRepository
        .updateUser(properties: const {'name': 'test1-for-test'});
    if (kDebugMode) {
      print(updateUser.name);
    }
    var me = await userRepository.me();
    expect(me.name, 'test1-for-test');
    updateUser = await userRepository
        .updateUser(properties: const {'name': 'test1test'});
    me = await userRepository.me();
    expect(me.name, 'test1test');
  });

  test('user repository refresh token', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Njk2MjQ0NTcsInVzZXIiOnsiaWQiOiJFMmt4eXJWcWY4VmpOd3A3XzRDX2MifX0.KO8is2W7CkHxjAWh3th2AdR9kEKNjepWTmBHiZCXijZT0CSYytDYkFQgALZI_RU95Gyj5w9Tgr6ZSg8DQYPtixFCJYIu9g0z2SkBo94XQZy3dbR6LPRkCK0nk5tsG9JvlkQ0rkFQ5B1xUZXdXaRXDseAoTNyjd7pu0TuMnFF1yLl_TEnLQh_wJyeT6NLqYyryGkNaUG5klpoukxNAdJuARlcNOZumi7Q_MMA94RqL9VnE-HfiqKRjhm470X0kOyg_XVLPRd0sUN8p2URrs_G-hhbFbZc7Vf3eXRNLy2ESa5R4NqVRKEExnt9PhNVlA_AC3WcpUHFipt1qcIYMu5YYg');
    var me = await userRepository.me();
    if (kDebugMode) {
      print(me.error);
    }
    expect(me.error, UserError.tokenExpired);
    userRepository.updateToken(
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg5ODE5NjYsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.Qb-2xHZ48j0XlTDvPQgbZPKH2tzg4n1x-zl_Dm7KKnx8Jsx4enNP_60W0DlQKON0Y-l4m87yP7-YUJNmpGbfFwHkmlXBOuagMui83194z28LdtmnMlB-p8W2nfD3AASCaGucrZFmuD6zHbZUonpsOAHJBxwPWY7jNjXpkBButbRrRVPcg6OAxgyND34rKUQb_Mskt-nBsPBkazVyUuV6eApvwyxDwrKq1cPNJtoGNWmKyypGhpvx9dSF2OinOlFlBmeNrITUH26H4lGukkWeDyNH_RVWNr-fMPv2Q7asULwvnx9o35L_0hLXrefYyQpvUSxMR7FTDp96k3Nm3T0_6A');

    me = await userRepository.me();
    if (kDebugMode) {
      print(me.error);
    }
    expect(me.error, UserError.none);
  });

  test('user repository preSignedAvatarUrl', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzk1MDI1NzAsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.lBtyGkA36K6YP2GQ9O3rXLeHCHz9Jb7KfMe3BxqoOLQG06r01BekXmb7frxxWl6J82c_gYpj1LXAS7r2PZtxCdgr-gCZgowpJzZG9hAkV_s8qXshK8EsjDaw5KRuF5ql6oMo7gJJ63GVyKD-7SZY-9L4dzPqNQTithyFhbiQxPs16T0r67qCJAvypD3Rpak2ZOrZ_-0ClyoH2Uo8UDrz3jf-SNOvdpouDM9yp6GXUoyaqTir4cM_BOwCJRcZMqr46v0oASyrHkm2U2CdxlhKqRS-NwwfFGoWvvI_9zTn7MD2OmXWNtO0XvIUHhoJQF_WnPn4gYdsXBKx3vVtu8b20A');
    var avatar = await userRepository.preSignedAvatarUrl();
    if (kDebugMode) {
      print(avatar.error);
    }
    expect(avatar.error, UserError.none);
    expect(avatar.preSignedUrl.isNotEmpty, true);
  });
}
