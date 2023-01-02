import 'apply_add_contacts.dart';

const isAgree = 'isAgree';
const replyAddContactsResult = 'replyAddContacts';
const replyAddContacts = '''
mutation $replyAddContactsResult(\$$contactsId: ID!, \$$isAgree: Boolean!, \$$remarkName: String!){
  $replyAddContactsResult(input: {
    $contactsId: \$$contactsId
    $isAgree: \$$isAgree
    $remarkName: \$$remarkName
  })
}
''';
