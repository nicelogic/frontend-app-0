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
    updateUser = await userRepository.updateUser(properties: const {'name': 'test1test'});
    me = await userRepository.me();
    expect(me.name, 'test1test');
  });
}
