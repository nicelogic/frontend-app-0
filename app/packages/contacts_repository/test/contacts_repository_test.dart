import 'dart:convert';

import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test contacts repository', () async {
    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODA0NDUyNzgsInVzZXIiOnsiaWQiOiJ2OWNlMHBxNXZ2dnNrNCJ9fQ.lQR6FvparOmuCW7GB4NuD3KhgcMmFRe4nPIuyjqihQOvVeMXU5nr4PoinDym3YEfFHJnu7MTI-pJip2iySi2rNPHPfs4HJ2X7ULFFhgp1_RbOWO-lWHI0MRsTEtIjFoLdzwZkFzrTR2rcZciNunh77vjGKsL8r-Kc5vLVFtDZsqGGhsgCRNMT-qUrCBcvSpMmZfotPmUZAnhwuc55WCYtHspPzxHi2p7r81Y4D1nXEflIrplYql9c8VRVO3aHVuUfgjNanvhtIUrpjn0ZfTQQal1YpJLIeID6hXrl8ciQ0s30SeqJlvGmYZ6SwuzyuQY34jC1NAgDBztTOtkLJn6xQ');
    final error = await contactsRepository.applyAddContacts(
        userName: 'test',
        contactsId: 'PKhB8wqChcyYPR',
        remarkName: 'test1---',
        message: 'please');
    if (kDebugMode) {
      print('user add contacts, result($error)');
    }
    expect(error, ContactsError.none);
  });

  test('test query addContactsApplys json parser', () async {
    const result = '''
  {
      "totalCount": 1,
      "edges": [
        {
          "node": {
            "userId": "v9ce0pq5vvvsk4",
            "contactsId": "PKhB8wqChcyYPR",
            "updateTime": "2023-01-02T09:50:16Z",
            "message": "please"
          },
          "cursor": null
        }
      ],
      "pageInfo": {
        "endCursor": "MjAyMy0wMS0wMlQwOTo1MDoxNlp8djljZTBwcTV2dnZzazQ=",
        "hasNextPage": false
      }
    }
''';
    if (kDebugMode) {
      print('result($result)');
    }
    final resultMap = jsonDecode(result);
    final connection = toAddContactsApplyConnection(resultMap);
    expect(connection.error, ContactsError.none);
    expect(connection.totalCount, 1);
    expect(connection.pageInfo.endCursor,
        'MjAyMy0wMS0wMlQwOTo1MDoxNlp8djljZTBwcTV2dnZzazQ=');
    expect(connection.pageInfo.hasNextPage, false);
    expect(connection.edges.length, 1);
    expect(connection.edges[0].cursour, null);
    expect(connection.edges[0].node.userId, 'v9ce0pq5vvvsk4');
    expect(connection.edges[0].node.contactsId, 'PKhB8wqChcyYPR');
    expect(connection.edges[0].node.message, 'please');
    expect(connection.edges[0].node.updateTime,
        DateTime.parse('2023-01-02T09:50:16Z'));
  });

  test('test contacts repository: query addContactsApplys', () async {
    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2NzY0NTksInVzZXIiOnsiaWQiOiJQS2hCOHdxQ2hjeVlQUiJ9fQ.bSPDw5fm9W2c4kVqdGLXYvvDAy-W0hzGQcEfZ9GotxezznWcHCl1CxYuJx57iFV9JvQE-2-BWOjejeO6fm2cxMj1U5Xh68JDSi2-mOSRp7AXzropCgIJonvQtOmnZ54MUiViK7TBVqPxvlWKiFB4nRdUMprTknMdjVUj7CxVb6-XuS9Op_XzxflYUERdo9WQlRNyDq3_1m8iJzQjRh0qFHE_kFfkQphxaWmklY-_ah5WFE9ZkPKWhG-uS5AYK-eVDzdMnb1zN7AcyvAc2Nfm0xbW5DZXGs2WiSSEcxLcq0CNz7WAPx4jvy2n6AbgIy5vRmGfgUk31iw7XZmRoI2SJQ');
    final connection = await contactsRepository.addContactsApplys(first: 100);
    if (kDebugMode) {
      print('result($connection)');
    }
    expect(connection.error, ContactsError.none);
    expect(connection.totalCount, 1);
    expect(connection.pageInfo.hasNextPage, false);
    expect(connection.edges.length, 1);
    expect(connection.edges[0].cursour, null);
    expect(connection.edges[0].node.userId, 'v9ce0pq5vvvsk4');
    expect(connection.edges[0].node.contactsId, 'PKhB8wqChcyYPR');
    expect(connection.edges[0].node.message, 'please');
  });

  test('test contacts repository: reply add contacts', () async {
    const testToken =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2OTAxNzgsInVzZXIiOnsiaWQiOiJ2OWNlMHBxNXZ2dnNrNCJ9fQ.bgizFow1-zRxsYl0GK64XuGCI_iqlANcat0iJdlM3vu0WBoWXHNczjf57zEPZ3MU0hE7ll5W_jb2WCyMZEazbYogz-l_57EKLF5islN4UgWTONjplyxd1MN3BKrLFUPPXjm7qDe_1UbjCOGjD1G21Tdr5Mcw6VMa9qdan8DT7j3qORe8L1g5Opu8hXp3wOEKUa2LenXCSIC_2MRoklEE_peYPozkGsVj1p2jjEqDQneh0GHPPzw2JHb_bWiWzgtgXabeYnNDECWnaSgGQ7GvcUZsYgx2S8vkz0ar9RxTC8kB_rFnMLSeeoUdEkfy_SOv_t4wcYJvhvm_PaX4TGz_LQ';
    const test1Token =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2ODUzNTYsInVzZXIiOnsiaWQiOiJQS2hCOHdxQ2hjeVlQUiJ9fQ.WAWBaKgshBH7gSX42T9RF7lAVP_V_Rv88THUd2Hnf6KG_3FbLHL5SQ931Iu3C-JAnZV3fyL5uLDyS5yrl6EYXtklYE3jMnm6ciFClQKVmAocNTeBe9DKJMv-ALQ_sUmvbZEGlzTsmp1oPp3Eqpshd8-9L0yE4bIshfkvEqL8vo5_-3Fh9fX3W-vkYDx7UZxK63b6qTjDdABF-RIEfdvHlO6ywiM-yPy7DXT463SmdLwz1ceFlH7sSI6d9r5gGcWgmU4hw9AtpcsYDLnb7blI2FK7vWB5CvKCT4VvmnP_ui2hkL_iDyjaxhDtg7zxrdcDeZdLnlmWs5EU6Ey2QRX2nw';
    const testId = 'v9ce0pq5vvvsk4';
    const test1Id = 'PKhB8wqChcyYPR';

    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token: testToken);
    final error = await contactsRepository.applyAddContacts(
        userName: 'test',
        contactsId: test1Id,
        remarkName: 'test1',
        message: 'please add me');
    if (kDebugMode) {
      print('user add contacts, result($error)');
    }
    expect(
        error == ContactsError.none || error == ContactsError.contactsAddedMe,
        true);
    final test1ContactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token: test1Token);
    final test1Error = await test1ContactsRepository.replyAddContacts(
        contactsId: testId, isAgree: true, remarkName: 'test');
    if (kDebugMode) {
      print('user reply add contacts, result($test1Error)');
    }
    expect(test1Error == ContactsError.none, true);
  });

  test('test contacts repository: query contacts', () async {
    const testToken =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2OTAxNzgsInVzZXIiOnsiaWQiOiJ2OWNlMHBxNXZ2dnNrNCJ9fQ.bgizFow1-zRxsYl0GK64XuGCI_iqlANcat0iJdlM3vu0WBoWXHNczjf57zEPZ3MU0hE7ll5W_jb2WCyMZEazbYogz-l_57EKLF5islN4UgWTONjplyxd1MN3BKrLFUPPXjm7qDe_1UbjCOGjD1G21Tdr5Mcw6VMa9qdan8DT7j3qORe8L1g5Opu8hXp3wOEKUa2LenXCSIC_2MRoklEE_peYPozkGsVj1p2jjEqDQneh0GHPPzw2JHb_bWiWzgtgXabeYnNDECWnaSgGQ7GvcUZsYgx2S8vkz0ar9RxTC8kB_rFnMLSeeoUdEkfy_SOv_t4wcYJvhvm_PaX4TGz_LQ';
    const test1Id = 'PKhB8wqChcyYPR';
    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token: testToken);
    final connection = await contactsRepository.contacts(first: 100);
    if (kDebugMode) {
      print('result($connection)');
    }
    expect(connection.error, ContactsError.none);
    expect(connection.totalCount, 1);
    expect(connection.pageInfo.hasNextPage, false);
    expect(connection.edges.length, 1);
    expect(connection.edges[0].cursour, null);
    expect(connection.edges[0].node.id, test1Id);
    expect(connection.edges[0].node.remarkName, 'test1');
  });

  test('test contacts repository: remove contacts', () async {
    const testToken =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2OTAxNzgsInVzZXIiOnsiaWQiOiJ2OWNlMHBxNXZ2dnNrNCJ9fQ.bgizFow1-zRxsYl0GK64XuGCI_iqlANcat0iJdlM3vu0WBoWXHNczjf57zEPZ3MU0hE7ll5W_jb2WCyMZEazbYogz-l_57EKLF5islN4UgWTONjplyxd1MN3BKrLFUPPXjm7qDe_1UbjCOGjD1G21Tdr5Mcw6VMa9qdan8DT7j3qORe8L1g5Opu8hXp3wOEKUa2LenXCSIC_2MRoklEE_peYPozkGsVj1p2jjEqDQneh0GHPPzw2JHb_bWiWzgtgXabeYnNDECWnaSgGQ7GvcUZsYgx2S8vkz0ar9RxTC8kB_rFnMLSeeoUdEkfy_SOv_t4wcYJvhvm_PaX4TGz_LQ';
    const test1Id = 'PKhB8wqChcyYPR';
    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token: testToken);
    final error = await contactsRepository.removeContacts(
      contactsId: test1Id,
    );
    if (kDebugMode) {
      print('user remove contacts, result($error)');
    }
    expect(error, ContactsError.none);
  });
}
