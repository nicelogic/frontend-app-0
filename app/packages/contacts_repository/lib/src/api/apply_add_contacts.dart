const kApplyAddContactsResult = 'applyAddContacts';
const userName = 'userName';
const contactsId = 'contactsId';
const remarkName = 'remarkName';
const message = 'message';
const kApplyAddContacts = '''
mutation $kApplyAddContactsResult(
                          \$$userName: String!
                          \$$contactsId: ID!
													\$$remarkName: String!
													\$$message: String!) {
  $kApplyAddContactsResult(
    input: {
      $userName: \$$userName
      $contactsId: \$$contactsId
      $remarkName: \$$remarkName
			$message: \$$message
    }
  )
}
''';
