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
}
