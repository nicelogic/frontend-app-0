import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test contacts repository', () async {
    final contactsRepository = ContactsRepository(
        url: 'https://contacts.app0.env0.luojm.com:9443/query',
        token:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzI2NjE5NzksInVzZXIiOnsiaWQiOiJ2OWNlMHBxNXZ2dnNrNCJ9fQ.Sb0X7jv-hmuDaI-XkDElUPXNNGB6UdMVv_H0AuZxv-_aVGyVZN3FybG-uYiMtSgjQNLk3RgGkPgNNu7aLxRhVl0GDFL5ACkd46BLxhe3ixQ9H-JoIejTnYAodbpFCYk_1y0fLc0kSIWjyZK-2qmNyzZzz1fE9xmlz8goSVW5WjbZgNVJV_fvpTo8mow_65hv-et6me3KItLC-E_A7b5SyqcLgTi8L6OBexLKPqxRqUFm0AyJjbhfespYAQR6_Oq0te7ppRLYCB6kRGI3YLM6f19TcaBMcZnngjJdC6pSSzW__3rCgVNA67LhsAQlcMZ2UPYm2rN7GNFdyKnenCQLjA');
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
}
