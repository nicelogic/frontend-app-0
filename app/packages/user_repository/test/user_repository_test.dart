import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:user_repository/user_repository.dart';

void main() {
  test('user repository me', () async {
    final userRepository = UserRepository(
        url: 'https://user.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg4OTU5MjMsInVzZXIiOnsiaWQiOiJaSThrTk5RYjR2b1o0dnFiM3VkcWIifX0.cGOHCHG5usUlL53DmpQxScHZiNYWDA-BWYYaO7Fk2iCIGXyhlavxNEonUDmDQKnTDltrlHIbWoraKWl9Ort-fpNkTLnk041TxU12PI9Mv4HADMMqJQ_r0574y5GDlBD5ru6xzqonGIsBECACoK0zxShMIJ3LE_jPb8ZDbGZzLHfeWWffK3Fo1dJ3wR9IAAZZAum3wfnnYZjRyZg2KYA9sNPbKwMHLnrsDpcdohI5SJinYp63v8kq_zJumiOJQJ209EHBRsip3g6HisHMZttMNxi_iMEsoLZtIMbh0tkFPkTN_K7qXe6Ic8GXD5Pn1cxWr7MLJ6O-qlzTX8q9T3dYHQ');
    final user = await userRepository.me();
    if (kDebugMode) {
      print('user id(${user.id}),name(${user.name}), data(${user.data}');
    }
    expect(user.name, 'test');
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
}
