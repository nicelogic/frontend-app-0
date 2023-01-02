const applyAddContactsResult = 'applyAddContacts';
const userName = 'userName';
const contactsId = 'contactsId';
const remarkName = 'remarkName';
const message = 'message';
const kApplyAddContacts = '''
mutation $applyAddContactsResult(
                          \$$userName: String!
                          \$$contactsId: ID!
													\$$remarkName: String!
													\$$message: String!) {
  $applyAddContactsResult(
    input: {
      $userName: \$$userName
      $contactsId: \$$contactsId
      $remarkName: \$$remarkName
			$message: \$$message
    }
  )
}
''';
