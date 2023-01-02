import 'apply_add_contacts.dart';

const removeContactsResult = 'removeContacts';
const removeContacts = '''
mutation $removeContactsResult(\$$contactsId: ID!){
  $removeContactsResult($contactsId: \$$contactsId)
}
''';
