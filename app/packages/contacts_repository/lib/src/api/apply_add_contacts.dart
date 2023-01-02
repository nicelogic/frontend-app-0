const kApplyAddContactsResult = 'applyAddContacts';
const kApplyAddContacts = '''
mutation $kApplyAddContactsResult(\$contactsId: ID!
  												\$userName: String!
													\$remarkName: String!
													\$message: String!) {
  $kApplyAddContactsResult(
    input: {
      contactsId: \$contactsId
      userName: \$userName
      remarkName: \$remarkName
			message: \$message
    }
  )
}
''';
